const accidentKeywords = [
  "accident",
  "crash",
  "collision",
  "knocked",
  "hit",
  "overturned",
  "skid",
  "injured",
  "injury",
  "fatal",
  "death",
  "dead",
  "ambulance",
  "police",
  "traffic",
  "road blocked",
  "road closed",
  "incident",
  "pile-up",
  "wreck",
  "smash",
];

const severeKeywords = [
  "fatal",
  "death",
  "dead",
  "critical",
  "serious",
  "ambulance",
  "police",
  "road closed",
  "heavily damaged",
  "multiple vehicles",
];

const mediumKeywords = [
  "injured",
  "collision",
  "crash",
  "traffic",
  "road blocked",
  "damage",
];

const mauritiusLocations = [
  "Port Louis",
  "Curepipe",
  "Quatre Bornes",
  "Rose Hill",
  "Vacoas",
  "Phoenix",
  "Beau Bassin",
  "Pailles",
  "Moka",
  "Ebene",
  "Ébène",
  "Réduit",
  "Reduit",
  "Trianon",
  "St Pierre",
  "Saint Pierre",
  "Cassis",
  "Coromandel",
  "Bambous",
  "Flic en Flac",
  "Flic-en-Flac",
  "Rose Belle",
  "Mahebourg",
  "Mahébourg",
  "Goodlands",
  "Grand Baie",
  "Pamplemousses",
  "Flacq",
  "Bel Air",
  "Roche Bois",
  "Triolet",
  "Souillac",
  "Camp Thorel",
  "L'Esperance",
  "L Esperance",
  "L’Espérance",
  "Espérance",
  "Esperance",
  "Sebastopol",
  "St Julien",
  "Saint Julien",
  "Quartier Militaire",
  "Pitot",
  "Verdun",
  "Highlands",
  "Plaine Magnien",
  "Rivière du Rempart",
  "Riviere du Rempart",
  "Terre Rouge",
  "Arsenal",
  "Beau Plan",
  "Le Hochet",
  "Montagne Blanche",
  "Nouvelle France",
  "La Louise",
  "Castel",
  "Eau Coulée",
  "Eau Coulee",
  "Henrietta",
  "Chemin Grenier",
  "Surinam",
  "Riche Terre",
  "Forbach",
  "Calebasses",
  "Mapou",
];

function normalizeText(text) {
  return (text || "").replace(/\s+/g, " ").trim();
}

function detectKeywords(text) {
  const lower = text.toLowerCase();
  return accidentKeywords.filter((word) => lower.includes(word.toLowerCase()));
}

function detectSeverity(text) {
  const lower = text.toLowerCase();

  const severeHits = severeKeywords.filter((word) =>
    lower.includes(word.toLowerCase())
  ).length;

  const mediumHits = mediumKeywords.filter((word) =>
    lower.includes(word.toLowerCase())
  ).length;

  const hasMultiVehicle =
    lower.includes("between two") ||
    lower.includes("two vehicles") ||
    lower.includes("two vans") ||
    lower.includes("multiple vehicles");

  if (severeHits >= 2) return "high";
  if (text.includes("under") || text.includes("crushed")) {
    return "high";
  }
  if (severeHits >= 1) return "medium";
  if (mediumHits >= 2 || hasMultiVehicle) return "medium";
  if (mediumHits >= 1) return "low";

  return "unknown";
}

function detectAccidentRelated(text) {
  const matchedKeywords = detectKeywords(text);
  const locations = extractPossibleLocations(text);

  let confidence = 0.1;
  const count = matchedKeywords.length;

  if (count >= 4) confidence = 0.95;
  else if (count === 3) confidence = 0.85;
  else if (count === 2) confidence = 0.72;
  else if (count === 1) confidence = 0.55;

  if (locations.length > 0 && confidence > 0.1) {
    confidence += 0.1;
  }

  if (confidence > 0.99) confidence = 0.99;

  return {
    isAccidentRelated: count > 0,
    confidence,
    matchedKeywords,
  };
}

function extractPossibleLocations(text) {
  const normalizedText = text
    .toLowerCase()
    .replace(/[’']/g, "'")
    .replace(/\s+/g, " ")
    .trim();

  const found = [];

  for (const place of mauritiusLocations) {
    const normalizedPlace = place
      .toLowerCase()
      .replace(/[’']/g, "'")
      .replace(/\s+/g, " ")
      .trim();

    if (normalizedText.includes(normalizedPlace)) {
      found.push(place);
    }
  }

  const canonicalMap = {
    "l'esperance": "L'Esperance",
    "esperance": "L'Esperance",
    "l esperance": "L'Esperance",
    "l’espérance": "L'Esperance",
    "réduit": "Réduit",
    "reduit": "Réduit",
    "ébène": "Ebene",
    "ebene": "Ebene",
    "mahébourg": "Mahebourg",
    "mahebourg": "Mahebourg",
    "rivière du rempart": "Rivière du Rempart",
    "riviere du rempart": "Rivière du Rempart",
  };

  const cleaned = found.map((place) => {
    const key = place
      .toLowerCase()
      .replace(/[’']/g, "'")
      .replace(/\s+/g, " ")
      .trim();

    return canonicalMap[key] || place;
  });

  return [...new Set(cleaned)].slice(0, 5);
}

function simpleSentimentScore(text) {
  const lower = text.toLowerCase();

  let score = 0;

  const negativeWords = [
    "accident",
    "crash",
    "collision",
    "injured",
    "fatal",
    "death",
    "dead",
    "blocked",
    "damage",
    "traffic",
    "serious",
    "critical",
  ];

  const positiveWords = [
    "safe",
    "cleared",
    "resolved",
    "recovered",
  ];

  negativeWords.forEach((word) => {
    if (lower.includes(word)) score -= 1;
  });

  positiveWords.forEach((word) => {
    if (lower.includes(word)) score += 1;
  });

  return score;
}

function buildSummary(isAccidentRelated, severity, locations) {
  if (!isAccidentRelated) {
    return "This post does not appear to describe a traffic accident.";
  }

  const locationPart =
    locations.length > 0 ? ` near ${locations.join(" / ")}` : "";

  const sev = severity === "unknown" ? "unspecified" : severity;

  return `Road accident reported${locationPart} with ${sev} severity.`;
}

function analyzePostText(text) {
  const cleanText = normalizeText(text);

  if (!cleanText) {
    return {
      cleanText: "",
      isAccidentRelated: false,
      confidence: 0,
      sentimentScore: 0,
      severity: "unknown",
      possibleLocations: [],
      keywords: [],
      nlpSummary: "No text available for analysis.",
    };
  }

  const accidentCheck = detectAccidentRelated(cleanText);
  const severity = detectSeverity(cleanText);
  const possibleLocations = extractPossibleLocations(cleanText);
  const sentimentScore = simpleSentimentScore(cleanText);

  return {
    cleanText,
    isAccidentRelated: accidentCheck.isAccidentRelated,
    confidence: accidentCheck.confidence,
    sentimentScore,
    severity,
    possibleLocations,
    keywords: accidentCheck.matchedKeywords,
    nlpSummary: buildSummary(
      accidentCheck.isAccidentRelated,
      severity,
      possibleLocations
    ),
  };
}

module.exports = { analyzePostText };