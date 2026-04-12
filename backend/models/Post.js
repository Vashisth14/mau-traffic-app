const mongoose = require("mongoose");

const PostSchema = new mongoose.Schema(
  {
    facebookPostId: {
      type: String,
      unique: true,
      index: true,
    },

    message: {
      type: String,
      trim: true,
    },

    story: {
      type: String,
      trim: true,
    },

    createdTime: {
      type: Date,
      index: true,
    },

    imageUrl: String,
    fullPicture: String,

    source: {
      type: String,
      default: "facebook",
    },

    syncedAt: {
      type: Date,
      default: Date.now,
    },

    // 🔥 NLP FIELDS
    isAccidentRelated: {
      type: Boolean,
      default: false,
    },

    confidence: {
      type: Number,
      default: 0,
    },

    severity: {
      type: String,
    },

    sentimentScore: {
      type: Number,
      default: 0,
    },

    possibleLocations: {
      type: [String],
      default: [],
    },

    keywords: {
      type: [String],
      default: [],
    },

    nlpSummary: String,
  },
  { timestamps: true }
);

module.exports = mongoose.model("Post", PostSchema);