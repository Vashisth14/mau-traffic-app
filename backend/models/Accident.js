const mongoose = require("mongoose");

const accidentSchema = new mongoose.Schema({
  location: {
    type: String,
    required: true,
    trim: true,
    index: true,
  },
  road: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  severity: {
    type: String,
    required: true,
    enum: ["Low", "Moderate", "High"],
    default: "Moderate",
  },
  vehicleType: {
    type: String,
    required: true,
    trim: true,
  },
  injuryReported: {
    type: Boolean,
    default: false,
  },
  roadBlocked: {
    type: Boolean,
    default: false,
  },
  useCurrentLocation: {
    type: Boolean,
    default: false,
  },

  // 🔥 NEW (future-ready)
  latitude: Number,
  longitude: Number,

  attachedImagePath: {
    type: String,
    default: null,
  },
  source: {
    type: String,
    default: "mobile",
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: true,
  },
});

module.exports = mongoose.model("Accident", accidentSchema);