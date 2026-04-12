const express = require("express");
const axios = require("axios");
const Post = require("../models/Post");
const { analyzePostText } = require("../nlpAnalyzer");

const router = express.Router();

async function syncFacebookPosts() {
  try {
    const fbUrl = `https://graph.facebook.com/v25.0/${process.env.FB_PAGE_ID}/posts`;

    const response = await axios.get(fbUrl, {
      params: {
        fields: "message,created_time,full_picture",
        access_token: process.env.FB_PAGE_ACCESS_TOKEN,
        limit: 25,
      },
    });

    const fbPosts = response.data.data || [];

    let inserted = 0;
    let updated = 0;

    // 🔥 Fetch all existing posts in ONE query
    const existingPosts = await Post.find({
      facebookPostId: { $in: fbPosts.map(p => p.id) },
    });

    const existingMap = new Map(
      existingPosts.map(p => [p.facebookPostId, p])
    );

    for (const item of fbPosts) {
      const text = item.message || "";
      const analysis = analyzePostText(text);

      const existingPost = existingMap.get(item.id);

      if (existingPost) {
        existingPost.message = text;
        existingPost.imageUrl = item.full_picture || null;
        existingPost.createdTime = new Date(item.created_time);

        existingPost.isAccidentRelated = analysis.isAccidentRelated;
        existingPost.confidence = analysis.confidence;
        existingPost.severity = analysis.severity;
        existingPost.sentimentScore = analysis.sentimentScore;
        existingPost.possibleLocations = analysis.possibleLocations;
        existingPost.keywords = analysis.keywords;
        existingPost.nlpSummary = analysis.nlpSummary;

        existingPost.syncedAt = new Date();

        await existingPost.save();
        updated++;
      } else {
        await Post.create({
          facebookPostId: item.id,
          message: text,
          imageUrl: item.full_picture || null,
          createdTime: new Date(item.created_time),
          source: "facebook",
          syncedAt: new Date(),

          isAccidentRelated: analysis.isAccidentRelated,
          confidence: analysis.confidence,
          severity: analysis.severity,
          sentimentScore: analysis.sentimentScore,
          possibleLocations: analysis.possibleLocations,
          keywords: analysis.keywords,
          nlpSummary: analysis.nlpSummary,
        });

        inserted++;
      }
    }

    return {
      inserted,
      updated,
      totalFetched: fbPosts.length,
    };
  } catch (error) {
    console.error(
      "Facebook API error:",
      error.response?.data || error.message
    );

    return {
      inserted: 0,
      updated: 0,
      totalFetched: 0,
      error: true,
    };
  }
}

// 🔹 Read posts from DB
router.get("/social-posts", async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdTime: -1 });
    res.json(posts);
  } catch (error) {
    console.error("Error fetching posts:", error);
    res.status(500).json({ error: "Failed to fetch posts" });
  }
});

// 🔹 Manual sync
router.post("/social-posts/sync", async (req, res) => {
  try {
    const result = await syncFacebookPosts();

    res.json({
      message: "Facebook sync completed",
      ...result,
    });
  } catch (error) {
    console.error(
      "Error syncing Facebook posts:",
      error.response?.data || error.message
    );

    res.status(500).json({
      error: "Failed to sync Facebook posts",
    });
  }
});

module.exports = {
  router,
  syncFacebookPosts,
};