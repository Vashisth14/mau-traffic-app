require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");
const fs = require("fs");
const multer = require("multer");

const connectDB = require("./config/db");
const { router: postsRoutes, syncFacebookPosts } = require("./routes/posts");
const Accident = require("./models/Accident");
const Post = require("./models/Post");
const { analyzePostText } = require("./nlpAnalyzer");

const app = express();

const PORT = process.env.PORT || 5000;
const SYNC_INTERVAL_MS = 5 * 60 * 1000;
let isSyncRunning = false;

app.use(
  cors({
    origin: process.env.CORS_ORIGIN?.split(",") || "*",
  })
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.send("MAU Traffic Backend Running");
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    service: "MAU Traffic Backend",
    timestamp: new Date().toISOString(),
  });
});

const uploadsDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    const sanitizedName = file.originalname.replace(/\s+/g, "_");
    const uniqueName = `${Date.now()}-${sanitizedName}`;
    cb(null, uniqueName);
  },
});

const allowedMimeTypes = ["image/jpeg", "image/png", "image/webp"];

const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
  fileFilter: (req, file, cb) => {
    if (!allowedMimeTypes.includes(file.mimetype)) {
      return cb(new Error("Only JPG, PNG, and WEBP images are allowed"));
    }
    cb(null, true);
  },
});

app.use("/uploads", express.static(uploadsDir));

function parseBoolean(value) {
  return value === true || value === "true";
}

function buildAbsoluteImageUrl(req, relativePath) {
  if (!relativePath) return null;

  if (process.env.PUBLIC_BASE_URL) {
    return `${process.env.PUBLIC_BASE_URL}${relativePath}`;
  }

  return `${req.protocol}://${req.get("host")}${relativePath}`;
}

function cleanText(value) {
  return typeof value === "string" ? value.trim() : "";
}

function buildAppPossibleLocations(report, analysis) {
  const locations = new Set();

  if (Array.isArray(analysis.possibleLocations)) {
    analysis.possibleLocations
      .map((item) => String(item).trim())
      .filter(Boolean)
      .forEach((item) => locations.add(item));
  }

  if (report.location) {
    locations.add(String(report.location).trim());
  }

  if (report.road) {
    locations.add(String(report.road).trim());
  }

  return Array.from(locations);
}

app.post("/api/accidents", (req, res, next) => {
  upload.single("image")(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      return res.status(400).json({
        message: "Image upload failed",
        error: err.message,
      });
    }

    if (err) {
      return res.status(400).json({
        message: "Invalid image upload",
        error: err.message,
      });
    }

    next();
  });
});

app.post("/api/accidents", async (req, res) => {
  try {
    const location = cleanText(req.body.location);
    const road = cleanText(req.body.road);
    const description = cleanText(req.body.description);
    const severity = cleanText(req.body.severity);
    const vehicleType = cleanText(req.body.vehicleType);

    const injuryReported = parseBoolean(req.body.injuryReported);
    const roadBlocked = parseBoolean(req.body.roadBlocked);
    const useCurrentLocation = parseBoolean(req.body.useCurrentLocation);

    if (!location || !road || !description || !severity || !vehicleType) {
      return res.status(400).json({
        message:
          "Location, road, description, severity, and vehicle type are required.",
      });
    }

    const attachedImagePath = req.file ? `/uploads/${req.file.filename}` : null;

    const accident = await Accident.create({
      location,
      road,
      description,
      severity,
      vehicleType,
      injuryReported,
      roadBlocked,
      useCurrentLocation,
      attachedImagePath,
      createdAt: new Date(),
    });

    return res.status(201).json({
      message: "Accident report saved successfully",
      accident,
    });
  } catch (error) {
    console.error("Error saving accident report:", error);
    return res.status(500).json({
      message: "Failed to save accident report",
      error: error.message,
    });
  }
});

app.get("/api/accidents", async (req, res) => {
  try {
    const accidents = await Accident.find().sort({ createdAt: -1 });
    return res.status(200).json(accidents);
  } catch (error) {
    console.error("Error fetching accidents:", error);
    return res.status(500).json({
      message: "Failed to fetch accidents",
      error: error.message,
    });
  }
});

app.get("/api/social-posts", async (req, res) => {
  try {
    const facebookPosts = await Post.find().lean();
    const appReports = await Accident.find().lean();

    console.log("Facebook posts found:", facebookPosts.length);
    console.log("App reports found:", appReports.length);

    const mappedFacebookPosts = facebookPosts.map((post) => {
      const text = post.message || post.story || "";
      const analysis = analyzePostText(text);

      return {
        id: post._id?.toString() || "",
        message: text,
        createdTime: post.createdTime
        ? new Date(post.createdTime).toISOString()
        : post.createdAt
            ? new Date(post.createdAt).toISOString()
            : new Date().toISOString(),
        fullPicture: post.imageUrl || post.fullPicture || null,
        source: "facebook",

        location: null,
        road: null,
        vehicleType: null,
        injuryReported: false,
        roadBlocked: false,

        isAccidentRelated: analysis.isAccidentRelated,
        confidence: analysis.confidence,
        severity: analysis.severity,
        sentimentScore: analysis.sentimentScore,
        possibleLocations: analysis.possibleLocations,
        keywords: analysis.keywords,
        nlpSummary: analysis.nlpSummary,
      };
    });

    const mappedAppReports = appReports.map((report) => {
      const text = report.description || "";
      const analysis = analyzePostText(text);

      return {
        id: report._id?.toString() || "",
        message: text,
        createdTime: report.createdAt || new Date().toISOString(),
        fullPicture: buildAbsoluteImageUrl(req, report.attachedImagePath),
        source: "app",

        location: report.location || null,
        road: report.road || null,
        vehicleType: report.vehicleType || null,
        injuryReported: report.injuryReported || false,
        roadBlocked: report.roadBlocked || false,

        isAccidentRelated: analysis.isAccidentRelated,
        confidence: analysis.confidence,
        severity: report.severity || analysis.severity,
        sentimentScore: analysis.sentimentScore,
        possibleLocations: buildAppPossibleLocations(report, analysis),
        keywords: analysis.keywords,
        nlpSummary: analysis.nlpSummary,
      };
    });

    const combinedFeed = [...mappedFacebookPosts, ...mappedAppReports].sort(
      (a, b) => new Date(b.createdTime) - new Date(a.createdTime)
    );

    return res.status(200).json(combinedFeed);
  } catch (error) {
    console.error("Error fetching combined feed:", error);
    return res.status(500).json({
      message: "Failed to fetch combined feed",
      error: error.message,
    });
  }
});

app.use("/api", postsRoutes);

async function runFacebookSync(label) {
  if (isSyncRunning) {
    console.log(`${label}: sync skipped because another sync is already running.`);
    return;
  }

  isSyncRunning = true;

  try {
    console.log(`${label}: starting Facebook sync...`);
    const result = await syncFacebookPosts();
    console.log(`${label}: Facebook sync completed:`, result);
  } catch (error) {
    console.error(
      `${label}: Facebook sync failed:`,
      error.response?.data || error.message
    );
  } finally {
    isSyncRunning = false;
  }
}

const startServer = async () => {
  try {
    await connectDB();

    app.listen(PORT, async () => {
      console.log(`Server running on port ${PORT}`);

      await runFacebookSync("Initial");

      setInterval(async () => {
        await runFacebookSync("Scheduled");
      }, SYNC_INTERVAL_MS);
    });
  } catch (error) {
    console.error("Server startup error:", error);
    process.exit(1);
  }
};

startServer();