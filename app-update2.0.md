# App Update 2.0 - Multi-Type Lesson System

---



## Overview

The Excel app supports **5 different lesson types** within courses. This document serves as the **single source of truth** for the mobile app to understand and extend lesson types, multilingual support, content storage formats, and data structures.

---

## Table of Contents

1. [Lesson Types](#lesson-types)
2. [Common Lesson Fields](#common-lesson-fields-all-types)
3. [Video Lesson](#1-video-lesson)
4. [Audio Lesson](#2-audio-lesson)
5. [Text Lesson](#3-text-lesson)
6. [Quiz Lesson](#4-quiz-lesson)
7. [Flashcard Lesson](#5-flashcard-lesson)
8. [Section Structure](#section-structure)
9. [Course Metadata](#course-metadata)
10. [Multilingual Support](#multilingual-support)
11. [AI Translation Generation](#ai-translation-generation)
12. [Duration Calculation](#duration-calculation)
13. [Firebase Limits](#firebase-limits)
14. [Language Resolution](#language-resolution)
15. [Backward Compatibility](#backward-compatibility)

---

## Lesson Types

| Type | Firestore Value | Icon | Description |
|------|-----------------|------|-------------|
| Video | `video` | play_circle | Video content with playback |
| Audio | `audio` | headphones | Audio/podcast content |
| Text | `text` | article | Reading/article content with rich text |
| Quiz | `quiz` | quiz | Interactive quiz with questions |
| Flashcard | `flashcard` | style | Flashcard deck for memorization |

---

## Type Discriminator

All lessons are stored in the `lessons` array within each section. Use the `type` field to determine which lesson type to render:

```dart
switch (lessonData['type']) {
  case 'video':
    // Render video player
  case 'audio':
    // Render audio player
  case 'text':
    // Render article/reading view with rich text
  case 'quiz':
    // Render quiz UI
  case 'flashcard':
    // Render flashcard UI
  default:
    // Fallback to video for backward compatibility
}
```

---

## Common Lesson Fields (All Types)

Every lesson type includes these base fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique identifier (format: `{type}_{sectionNumber}_{rowNumber}`) |
| `type` | String | Yes | Type discriminator (`video`, `audio`, `text`, `quiz`, `flashcard`) |
| `title` | String | Yes | English title |
| `isPremium` | bool | No | Premium content flag (default: false) |
| `sectionNumber` | int | Yes | Section this lesson belongs to |
| `rowNumber` | int | Yes | Order within the section |
| `row` | int | Yes | Legacy field (same as rowNumber, for backward compatibility) |
| `createdAt` | String/Timestamp | No | Creation timestamp (ISO 8601 string) |
| `updatedAt` | String/Timestamp | No | Last update timestamp (ISO 8601 string) |

### Multi-Language Titles (All Types)

| Field | Language |
|-------|----------|
| `title_de` | German |
| `title_es` | Spanish |
| `title_fr` | French |
| `title_ja` | Japanese |
| `title_ko` | Korean |
| `title_zh` | Simplified Chinese |

---

## 1. VIDEO Lesson

Video lessons for watching instructional content.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `videoUrl` | String | Yes | URL to video file (Firebase Storage or external) |
| `thumbnailUrl` | String | No | Thumbnail image URL |
| `duration` | int | Yes | Duration in seconds |
| `description` | String | No | English description |
| `category` | String | Yes | Category (legacy field, used for grouping) |
| `tags` | List<String> | No | Tags for filtering |

### Multi-Language Description

| Field | Language |
|-------|----------|
| `description_de` | German |
| `description_es` | Spanish |
| `description_fr` | French |
| `description_ja` | Japanese |
| `description_ko` | Korean |
| `description_zh` | Simplified Chinese |

### Firestore Example

```json
{
  "id": "video_1_1",
  "type": "video",
  "title": "Introduction to Excel",
  "title_de": "Einführung in Excel",
  "title_es": "Introducción al Excel",
  "title_fr": "Introduction au Excel",
  "title_ja": "気功入門",
  "title_ko": "기공 소개",
  "title_zh": "气功入门",
  "videoUrl": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/video%2Fintro.mp4",
  "thumbnailUrl": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/thumbs%2Fintro.jpg",
  "duration": 600,
  "description": "Learn the fundamentals of Excel practice.",
  "description_de": "Lernen Sie die Grundlagen der Excel-Praxis.",
  "description_es": "Aprende los fundamentos de la práctica de Excel.",
  "category": "fundamentals",
  "sectionNumber": 1,
  "rowNumber": 1,
  "row": 1,
  "isPremium": false,
  "tags": ["beginner", "basics"],
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

### UI Implementation

- Display video player with controls
- Show thumbnail before playback
- Display duration as MM:SS
- Show description below video
- Support fullscreen playback

---

## 2. AUDIO Lesson

Audio content like guided meditations, podcasts, or audio instructions.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `audioUrl` | String | Yes | URL to audio file (Firebase Storage or external) |
| `thumbnailUrl` | String | No | Cover image URL |
| `duration` | int | Yes | Duration in seconds |
| `description` | String | No | English description |

### Multi-Language Description

| Field | Language |
|-------|----------|
| `description_de` | German |
| `description_es` | Spanish |
| `description_fr` | French |
| `description_ja` | Japanese |
| `description_ko` | Korean |
| `description_zh` | Simplified Chinese |

### Firestore Example

```json
{
  "id": "audio_1_2",
  "type": "audio",
  "title": "Morning Meditation",
  "title_de": "Morgenmeditation",
  "title_es": "Meditación matutina",
  "title_fr": "Méditation du matin",
  "title_ja": "朝の瞑想",
  "title_ko": "아침 명상",
  "title_zh": "早晨冥想",
  "audioUrl": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/audio%2Fmorning.mp3",
  "thumbnailUrl": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/thumbs%2Fmeditation.jpg",
  "duration": 900,
  "description": "A 15-minute guided morning meditation.",
  "description_de": "Eine 15-minütige geführte Morgenmeditation.",
  "description_es": "Una meditación matutina guiada de 15 minutos.",
  "sectionNumber": 1,
  "rowNumber": 2,
  "row": 2,
  "isPremium": false,
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

### UI Implementation

- Display audio player with play/pause, seek bar
- Show cover image/thumbnail
- Display duration as MM:SS
- Show title and description
- Consider background playback support

---

## 3. TEXT Lesson

Article/reading content with **rich text support** using Quill Delta JSON format.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `content` | String | Yes | **Quill Delta JSON** or plain text (see Content Format below) |
| `thumbnailUrl` | String | No | Thumbnail image URL |
| `banner_url` | String | No | **Top banner image URL** (displayed at top of article) |
| `estimatedReadTime` | int | Yes | Reading time in seconds |
| `duration` | int | Yes | Same as estimatedReadTime (for compatibility) |

### Multi-Language Content

| Field | Language |
|-------|----------|
| `content_de` | German (Quill Delta JSON) |
| `content_es` | Spanish (Quill Delta JSON) |
| `content_fr` | French (Quill Delta JSON) |
| `content_ja` | Japanese (Quill Delta JSON) |
| `content_ko` | Korean (Quill Delta JSON) |
| `content_zh` | Simplified Chinese (Quill Delta JSON) |

### Content Format - Quill Delta JSON

**IMPORTANT:** Text content is stored as **Quill Delta JSON**, not HTML. This allows rich text formatting support.

#### Quill Delta JSON Structure

The content is a JSON array of operations (ops). Each operation describes a piece of content with optional attributes:

```json
[
  {"insert": "Introduction\n", "attributes": {"header": 2}},
  {"insert": "Excel is an ancient Chinese practice that combines "},
  {"insert": "meditation", "attributes": {"bold": true}},
  {"insert": ", "},
  {"insert": "breathing techniques", "attributes": {"italic": true}},
  {"insert": ", and gentle movements.\n\n"},
  {"insert": "Key Benefits:\n", "attributes": {"header": 3}},
  {"insert": "Improved energy flow\n", "attributes": {"list": "bullet"}},
  {"insert": "Better balance and flexibility\n", "attributes": {"list": "bullet"}},
  {"insert": "Reduced stress\n", "attributes": {"list": "bullet"}}
]
```

#### Supported Formatting Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `bold` | bool | Bold text |
| `italic` | bool | Italic text |
| `underline` | bool | Underlined text |
| `strike` | bool | Strikethrough text |
| `header` | int (1-6) | Header level |
| `list` | "bullet" / "ordered" | List item |
| `blockquote` | bool | Block quote |
| `code-block` | bool | Code block |
| `link` | String | Hyperlink URL |
| `align` | "left" / "center" / "right" / "justify" | Text alignment |
| `indent` | int | Indentation level |

#### Parsing Quill Delta in Flutter/Dart

```dart
import 'dart:convert';

// Parse the content
List<dynamic> deltaOps = jsonDecode(content);

// Option 1: Use flutter_quill package
import 'package:flutter_quill/flutter_quill.dart';

Document document = Document.fromJson(deltaOps);
QuillController controller = QuillController(
  document: document,
  selection: const TextSelection.collapsed(offset: 0),
);

// Display with QuillEditor (read-only mode)
QuillEditor(
  controller: controller,
  readOnly: true,
  expands: false,
  autoFocus: false,
)

// Option 2: Extract plain text for simple display
String plainText = document.toPlainText();
```

#### Backward Compatibility for Plain Text

The content field may contain plain text (not JSON) for older lessons. Handle this gracefully:

```dart
String parseContent(String content) {
  try {
    // Try to parse as Delta JSON first
    final deltaJson = jsonDecode(content);
    if (deltaJson is List) {
      Document doc = Document.fromJson(deltaJson);
      return doc.toPlainText(); // Or render with Quill
    }
  } catch (_) {
    // Not valid JSON, treat as plain text
  }
  return content; // Return as-is (plain text)
}
```

### Banner Image

The `banner_url` field contains the URL for a **top banner image** that should be displayed at the top of the text lesson, before the content. This is different from `thumbnailUrl` which is used for previews/lists.

**Display guidelines:**
- Display banner at full width at the top of the article
- Maintain aspect ratio (typically 16:9 or 3:1)
- Can be tapped to view full-size
- If no banner_url is provided, skip the banner section

### Firestore Example

```json
{
  "id": "text_1_3",
  "type": "text",
  "title": "The Philosophy of Excel",
  "title_de": "Die Philosophie des Excel",
  "title_es": "La filosofía del Excel",
  "title_fr": "La philosophie du Excel",
  "title_ja": "気功の哲学",
  "title_ko": "기공의 철학",
  "title_zh": "气功哲学",
  "content": "[{\"insert\":\"Introduction\\n\",\"attributes\":{\"header\":2}},{\"insert\":\"Excel is an ancient Chinese practice...\\n\"}]",
  "content_de": "[{\"insert\":\"Einführung\\n\",\"attributes\":{\"header\":2}},{\"insert\":\"Excel ist eine alte chinesische Praxis...\\n\"}]",
  "content_es": "[{\"insert\":\"Introducción\\n\",\"attributes\":{\"header\":2}},{\"insert\":\"Excel es una antigua práctica china...\\n\"}]",
  "thumbnailUrl": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/thumbs%2Fphilosophy.jpg",
  "banner_url": "https://firebasestorage.googleapis.com/v0/b/qigong-workout.appspot.com/o/banners%2Fphilosophy_banner.jpg",
  "estimatedReadTime": 300,
  "duration": 300,
  "sectionNumber": 1,
  "rowNumber": 3,
  "row": 3,
  "isPremium": false,
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

### Read Time Calculation

Estimated read time is calculated at ~200 words per minute:

```dart
static int calculateReadTime(String text) {
  if (text.isEmpty) return 0;
  final wordCount = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  // Average reading speed: 200 words per minute
  return ((wordCount / 200) * 60).ceil();
}
```

### UI Implementation

- Display banner image at top (if `banner_url` exists)
- Render rich text content using Quill or custom renderer
- Show estimated read time (e.g., "5 min read")
- Support scrolling for long articles
- Consider text size adjustments for accessibility
- Support dark/light mode for content

---

## 4. QUIZ Lesson

Interactive quizzes to test knowledge with single-choice questions.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `description` | String | No | Quiz instructions/description |
| `questions` | List | Yes | Array of question objects |
| `passingPercentage` | int | No | Pass threshold (default: 70%) |
| `duration` | int | No | Estimated duration in seconds (auto-calculated) |

### Multi-Language Description

| Field | Language |
|-------|----------|
| `description_de` | German |
| `description_es` | Spanish |
| `description_fr` | French |
| `description_ja` | Japanese |
| `description_ko` | Korean |
| `description_zh` | Simplified Chinese |

### Question Object Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique question ID |
| `questionText` | String | Yes | English question text |
| `options` | List | Yes | Array of option objects |
| `correctOptionIndex` | int | Yes | Index of correct answer (0-based) |

#### Multi-Language Question Text

| Field | Language |
|-------|----------|
| `questionText_de` | German |
| `questionText_es` | Spanish |
| `questionText_fr` | French |
| `questionText_ja` | Japanese |
| `questionText_ko` | Korean |
| `questionText_zh` | Simplified Chinese |

### Option Object Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique option ID |
| `text` | String | Yes | English option text |

#### Multi-Language Option Text

| Field | Language |
|-------|----------|
| `text_de` | German |
| `text_es` | Spanish |
| `text_fr` | French |
| `text_ja` | Japanese |
| `text_ko` | Korean |
| `text_zh` | Simplified Chinese |

### Firestore Example

```json
{
  "id": "quiz_1_4",
  "type": "quiz",
  "title": "Excel Basics Quiz",
  "title_de": "Excel Grundlagen Quiz",
  "title_es": "Quiz de Fundamentos de Excel",
  "title_fr": "Quiz sur les bases du Excel",
  "title_ja": "気功基礎クイズ",
  "title_ko": "기공 기초 퀴즈",
  "title_zh": "气功基础测验",
  "description": "Test your understanding of Excel fundamentals.",
  "description_de": "Testen Sie Ihr Verständnis der Excel-Grundlagen.",
  "description_es": "Pon a prueba tu comprensión de los fundamentos del Excel.",
  "passingPercentage": 70,
  "duration": 90,
  "sectionNumber": 1,
  "rowNumber": 4,
  "row": 4,
  "isPremium": false,
  "questions": [
    {
      "id": "q1",
      "questionText": "What does 'Qi' mean?",
      "questionText_de": "Was bedeutet 'Qi'?",
      "questionText_es": "¿Qué significa 'Qi'?",
      "questionText_fr": "Que signifie 'Qi'?",
      "questionText_ja": "「気」とは何を意味しますか？",
      "questionText_ko": "'기'는 무엇을 의미합니까?",
      "questionText_zh": "'气'是什么意思？",
      "options": [
        {
          "id": "q1_opt1",
          "text": "Life energy",
          "text_de": "Lebensenergie",
          "text_es": "Energía vital",
          "text_fr": "Énergie vitale",
          "text_ja": "生命エネルギー",
          "text_ko": "생명 에너지",
          "text_zh": "生命能量"
        },
        {
          "id": "q1_opt2",
          "text": "Physical strength",
          "text_de": "Körperliche Stärke",
          "text_es": "Fuerza física",
          "text_fr": "Force physique",
          "text_ja": "体力",
          "text_ko": "체력",
          "text_zh": "体力"
        },
        {
          "id": "q1_opt3",
          "text": "Mental focus",
          "text_de": "Geistige Konzentration",
          "text_es": "Enfoque mental",
          "text_fr": "Concentration mentale",
          "text_ja": "精神集中",
          "text_ko": "정신 집중",
          "text_zh": "精神集中"
        },
        {
          "id": "q1_opt4",
          "text": "Breathing technique",
          "text_de": "Atemtechnik",
          "text_es": "Técnica de respiración",
          "text_fr": "Technique de respiration",
          "text_ja": "呼吸法",
          "text_ko": "호흡 기술",
          "text_zh": "呼吸技术"
        }
      ],
      "correctOptionIndex": 0
    }
  ],
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

### UI Implementation

- Display questions one at a time or all at once
- Show multiple choice options (single selection)
- Highlight correct/incorrect answers after selection
- Track score and show results at the end
- Display passing percentage requirement
- Show quiz progress (e.g., "Question 2 of 5")
- **Estimated duration:** 30 seconds per question

---

## 5. FLASHCARD Lesson

Flashcard decks for memorization and study.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `description` | String | No | Deck description |
| `cards` | List | Yes | Array of flashcard objects |
| `duration` | int | No | Estimated duration in seconds (auto-calculated) |

### Multi-Language Description

| Field | Language |
|-------|----------|
| `description_de` | German |
| `description_es` | Spanish |
| `description_fr` | French |
| `description_ja` | Japanese |
| `description_ko` | Korean |
| `description_zh` | Simplified Chinese |

### Flashcard Item Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique card ID |
| `frontText` | String | Yes | Front of card (English) |
| `backText` | String | Yes | Back of card (English) |

#### Multi-Language Front Text

| Field | Language |
|-------|----------|
| `frontText_de` | German |
| `frontText_es` | Spanish |
| `frontText_fr` | French |
| `frontText_ja` | Japanese |
| `frontText_ko` | Korean |
| `frontText_zh` | Simplified Chinese |

#### Multi-Language Back Text

| Field | Language |
|-------|----------|
| `backText_de` | German |
| `backText_es` | Spanish |
| `backText_fr` | French |
| `backText_ja` | Japanese |
| `backText_ko` | Korean |
| `backText_zh` | Simplified Chinese |

### Firestore Example

```json
{
  "id": "flashcard_1_5",
  "type": "flashcard",
  "title": "Excel Terminology",
  "title_de": "Excel-Terminologie",
  "title_es": "Terminología de Excel",
  "title_fr": "Terminologie du Excel",
  "title_ja": "気功用語",
  "title_ko": "기공 용어",
  "title_zh": "气功术语",
  "description": "Learn essential Excel terms.",
  "description_de": "Lernen Sie wichtige Excel-Begriffe.",
  "description_es": "Aprende términos esenciales de Excel.",
  "duration": 20,
  "sectionNumber": 1,
  "rowNumber": 5,
  "row": 5,
  "isPremium": false,
  "cards": [
    {
      "id": "card1",
      "frontText": "Qi",
      "backText": "Life force or vital energy that flows through all living things",
      "frontText_de": "Qi",
      "backText_de": "Lebenskraft oder Vitalenergie, die durch alle Lebewesen fließt",
      "frontText_es": "Qi",
      "backText_es": "Fuerza vital o energía que fluye a través de todos los seres vivos",
      "frontText_fr": "Qi",
      "backText_fr": "Force vitale ou énergie qui circule à travers tous les êtres vivants",
      "frontText_ja": "気",
      "backText_ja": "すべての生き物を通じて流れる生命力またはエネルギー",
      "frontText_ko": "기",
      "backText_ko": "모든 생명체를 통해 흐르는 생명력 또는 에너지",
      "frontText_zh": "气",
      "backText_zh": "流经所有生命体的生命力或能量"
    },
    {
      "id": "card2",
      "frontText": "Dantian",
      "backText": "Energy center located in the lower abdomen",
      "frontText_de": "Dantian",
      "backText_de": "Energiezentrum im Unterbauch",
      "frontText_es": "Dantian",
      "backText_es": "Centro de energía ubicado en el abdomen inferior",
      "frontText_fr": "Dantian",
      "backText_fr": "Centre d'énergie situé dans le bas de l'abdomen",
      "frontText_ja": "丹田",
      "backText_ja": "下腹部にあるエネルギーセンター",
      "frontText_ko": "단전",
      "backText_ko": "하복부에 위치한 에너지 중심",
      "frontText_zh": "丹田",
      "backText_zh": "位于下腹部的能量中心"
    }
  ],
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

### UI Implementation

- Display card front with tap-to-flip animation
- Show card back on flip
- Support swipe gestures for next/previous
- Track progress through deck
- Consider "know it" / "study again" sorting
- Show card progress (e.g., "Card 3 of 10")
- **Estimated duration:** 10 seconds per card

---

## Section Structure

Sections contain mixed lesson types in a single `lessons` array.

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique section ID (format: `section_{number}`) |
| `sectionNumber` | int | Yes | Section number |
| `title` | String | Yes | English section title |
| `description` | String | Yes | English section description |
| `order` | int | Yes | Display order |
| `lessons` | List | Yes | Array of lesson objects (mixed types) |
| `videos` | List | Yes | **Same as lessons** (for backward compatibility) |

### Multi-Language Title

| Field | Language |
|-------|----------|
| `title_de` | German |
| `title_es` | Spanish |
| `title_fr` | French |
| `title_ja` | Japanese |
| `title_ko` | Korean |
| `title_zh` | Simplified Chinese |

### Important: Backward Compatibility

The section stores lessons in **both** `lessons` and `videos` arrays with identical content. This ensures backward compatibility with older app versions that only read the `videos` array.

When reading:
```dart
// Try 'lessons' first, fallback to 'videos'
List<dynamic>? lessonsData = map['lessons'] as List<dynamic>?;
lessonsData ??= map['videos'] as List<dynamic>?;
```

### Firestore Example

```json
{
  "id": "section_1",
  "sectionNumber": 1,
  "title": "Getting Started",
  "title_de": "Erste Schritte",
  "title_es": "Comenzando",
  "title_fr": "Commencer",
  "title_ja": "はじめに",
  "title_ko": "시작하기",
  "title_zh": "入门",
  "description": "Introduction to the basics",
  "order": 1,
  "lessons": [
    { "type": "video", "id": "video_1_1", "title": "...", ... },
    { "type": "audio", "id": "audio_1_2", "title": "...", ... },
    { "type": "text", "id": "text_1_3", "title": "...", ... },
    { "type": "quiz", "id": "quiz_1_4", "title": "...", ... },
    { "type": "flashcard", "id": "flashcard_1_5", "title": "...", ... }
  ],
  "videos": [
    { "type": "video", "id": "video_1_1", "title": "...", ... },
    { "type": "audio", "id": "audio_1_2", "title": "...", ... },
    { "type": "text", "id": "text_1_3", "title": "...", ... },
    { "type": "quiz", "id": "quiz_1_4", "title": "...", ... },
    { "type": "flashcard", "id": "flashcard_1_5", "title": "...", ... }
  ]
}
```

---

## Course Metadata

The course includes metadata with counts for all lesson types.

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `totalVideos` | int | Total video lessons |
| `totalAudios` | int | Total audio lessons |
| `totalTextLessons` | int | Total text lessons |
| `totalQuizzes` | int | Total quizzes |
| `totalFlashcards` | int | Total flashcard decks |
| `totalDuration` | int | Total duration in seconds |
| `totalSections` | int | Total sections |
| `premiumVideos` | int | Premium video count |
| `premiumAudios` | int | Premium audio count |
| `premiumTextLessons` | int | Premium text count |
| `premiumQuizzes` | int | Premium quiz count |
| `premiumFlashcards` | int | Premium flashcard count |
| `freeVideos` | int | Free video count |

### Firestore Example

```json
{
  "metadata": {
    "totalVideos": 12,
    "totalAudios": 5,
    "totalTextLessons": 8,
    "totalQuizzes": 4,
    "totalFlashcards": 3,
    "totalDuration": 14400,
    "totalSections": 5,
    "premiumVideos": 3,
    "premiumAudios": 1,
    "premiumTextLessons": 2,
    "premiumQuizzes": 1,
    "premiumFlashcards": 0,
    "freeVideos": 9
  }
}
```

---

## Multilingual Support

### Supported Languages

| Code | Language | Flag |
|------|----------|------|
| `en` | English (Primary) | - |
| `de` | German | 🇩🇪 |
| `es` | Spanish | 🇪🇸 |
| `fr` | French | 🇫🇷 |
| `ja` | Japanese | 🇯🇵 |
| `ko` | Korean | 🇰🇷 |
| `zh` | Chinese (Simplified) | 🇨🇳 |

### Field Naming Convention

All translatable fields follow this pattern:

| Content Type | English Field | Translated Field Pattern |
|--------------|---------------|--------------------------|
| Title | `title` | `title_{langCode}` (e.g., `title_de`) |
| Description | `description` | `description_{langCode}` |
| Content | `content` | `content_{langCode}` |
| Question Text | `questionText` | `questionText_{langCode}` |
| Option Text | `text` | `text_{langCode}` |
| Front Text | `frontText` | `frontText_{langCode}` |
| Back Text | `backText` | `backText_{langCode}` |

### Translation Fallback

Always fall back to English if a translation is not available:

```dart
String getLocalizedField(Map data, String field, String languageCode) {
  // Skip if requesting English (no suffix)
  if (languageCode == 'en') {
    return data[field] ?? '';
  }

  // Try language-specific field first
  String localizedKey = '${field}_$languageCode';
  if (data[localizedKey] != null && data[localizedKey].toString().isNotEmpty) {
    return data[localizedKey];
  }

  // Fall back to English
  return data[field] ?? '';
}

// Usage examples:
String title = getLocalizedField(lesson, 'title', 'de');
String description = getLocalizedField(lesson, 'description', 'es');
String content = getLocalizedField(lesson, 'content', 'fr');
String questionText = getLocalizedField(question, 'questionText', 'ja');
String optionText = getLocalizedField(option, 'text', 'ko');
String frontText = getLocalizedField(card, 'frontText', 'zh');
String backText = getLocalizedField(card, 'backText', 'zh');
```

---

## AI Translation Generation

The web admin panel supports **automatic translation generation** using Claude AI. This feature generates translations for all 6 languages from English source text.

### How It Works

1. User enters English content in the web panel
2. User clicks "Auto Generate" button in the translations section
3. Web panel calls Firebase Cloud Function with the English text
4. Cloud Function calls Claude AI (Haiku 4.5 model) to generate translations
5. Translations are returned as JSON and populated in the form

### Firebase Cloud Function Details

**Function Name:** `generateText`
**URL:** `https://us-central1-qigong-workout.cloudfunctions.net/generateText`
**Model:** Claude Haiku 4.5 (`claude-haiku-4-5`)

#### Request Format

```http
POST /generateText
Authorization: Bearer <firebase-id-token>
Content-Type: application/json

{
  "prompt": "Translate the following English text to these languages: German, Spanish, French, Japanese, Korean, Chinese (Simplified).\n\nReturn ONLY a valid JSON object with language codes as keys and translations as values.\n\nText to translate:\nHello, welcome to Excel!",
  "maxTokens": 2048
}
```

#### Response Format

```json
{
  "success": true,
  "response": "{\"de\": \"Hallo, willkommen bei Excel!\", \"es\": \"¡Hola, bienvenido al Excel!\", \"fr\": \"Bonjour, bienvenue au Excel!\", \"ja\": \"こんにちは、気功へようこそ！\", \"ko\": \"안녕하세요, 기공에 오신 것을 환영합니다!\", \"zh\": \"你好，欢迎来到气功！\"}",
  "usage": {
    "inputTokens": 150,
    "outputTokens": 120
  }
}
```

### Important Notes

- AI translations are generated from English source only
- Translations can be manually edited after generation
- Text lessons translate both title and content (plain text, not formatting)
- Quiz questions translate question text and all option texts
- Flashcards translate both front and back text

---

## Duration Calculation

Each lesson type calculates estimated duration differently:

| Type | Calculation | Storage |
|------|-------------|---------|
| Video | `duration` field (actual video duration) | Stored in `duration` |
| Audio | `duration` field (actual audio duration) | Stored in `duration` |
| Text | `estimatedReadTime` (~200 words/min) | Stored in both `estimatedReadTime` and `duration` |
| Quiz | `questions.length * 30` seconds | Auto-calculated, stored in `duration` |
| Flashcard | `cards.length * 10` seconds | Auto-calculated, stored in `duration` |

### Dart Implementation

```dart
int getEstimatedDuration(Map lesson) {
  final type = lesson['type'] ?? 'video';

  switch (type) {
    case 'video':
    case 'audio':
      return lesson['duration'] ?? 0;

    case 'text':
      return lesson['estimatedReadTime'] ?? lesson['duration'] ?? 0;

    case 'quiz':
      final questions = lesson['questions'] as List? ?? [];
      return questions.length * 30;

    case 'flashcard':
      final cards = lesson['cards'] as List? ?? [];
      return cards.length * 10;

    default:
      return lesson['duration'] ?? 0;
  }
}
```

---

## Firebase Limits

The system enforces the following limits:

| Limit | Value | Description |
|-------|-------|-------------|
| `maxCoursesPerPage` | 20 | Courses per pagination page |
| `maxVideosPerSection` | 50 | Max video lessons per section |
| `maxLessonsPerSection` | 50 | Max total lessons per section |
| `maxSectionsPerCourse` | 20 | Max sections per course |
| `maxQuestionsPerQuiz` | 50 | Max questions per quiz |
| `maxOptionsPerQuestion` | 6 | Max options per quiz question |
| `maxCardsPerFlashcard` | 100 | Max cards per flashcard deck |

### Firebase Collections

| Collection | Description |
|------------|-------------|
| `courses` | Main course documents |
| `users` | User profiles |
| `deleted_courses` | Archived/soft-deleted courses |

---

## Language Resolution

When displaying content in the app, use this comprehensive helper:

```dart
class LocalizationHelper {
  static String getLocalizedField(
    Map<String, dynamic> data,
    String field,
    String languageCode,
  ) {
    // English is the default, no suffix
    if (languageCode == 'en') {
      return data[field]?.toString() ?? '';
    }

    // Try language-specific field
    String localizedKey = '${field}_$languageCode';
    final localizedValue = data[localizedKey];

    if (localizedValue != null && localizedValue.toString().isNotEmpty) {
      return localizedValue.toString();
    }

    // Fall back to English
    return data[field]?.toString() ?? '';
  }

  /// For nested objects like quiz questions and flashcard items
  static String getNestedLocalizedField(
    Map<String, dynamic> data,
    String field,
    String languageCode,
  ) {
    return getLocalizedField(data, field, languageCode);
  }
}

// Usage in UI
Widget buildLessonTile(Map<String, dynamic> lesson, String userLanguage) {
  final type = lesson['type'] ?? 'video';
  final title = LocalizationHelper.getLocalizedField(lesson, 'title', userLanguage);

  IconData icon;
  String subtitle;

  switch (type) {
    case 'video':
      icon = Icons.play_circle;
      subtitle = formatDuration(lesson['duration'] ?? 0);
      break;
    case 'audio':
      icon = Icons.headphones;
      subtitle = formatDuration(lesson['duration'] ?? 0);
      break;
    case 'text':
      icon = Icons.article;
      int minutes = ((lesson['estimatedReadTime'] ?? 0) / 60).ceil();
      subtitle = '$minutes min read';
      break;
    case 'quiz':
      icon = Icons.quiz;
      int questionCount = (lesson['questions'] as List?)?.length ?? 0;
      subtitle = '$questionCount questions';
      break;
    case 'flashcard':
      icon = Icons.style;
      int cardCount = (lesson['cards'] as List?)?.length ?? 0;
      subtitle = '$cardCount cards';
      break;
    default:
      icon = Icons.play_circle;
      subtitle = formatDuration(lesson['duration'] ?? 0);
  }

  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: lesson['isPremium'] == true ? Icon(Icons.lock) : null,
  );
}

String formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
```

---

## Backward Compatibility

When implementing the app, ensure these backward compatibility measures:

### 1. Default Type
If the `type` field is missing, treat the lesson as `video`:

```dart
final type = lessonData['type'] ?? 'video';
```

### 2. Videos Array Fallback
Sections have both `lessons` and `videos` arrays. Try `lessons` first:

```dart
List<dynamic>? lessonsData = map['lessons'];
lessonsData ??= map['videos'];
```

### 3. Row Number Fields
Both `rowNumber` and `row` fields exist. Use either:

```dart
final rowNumber = map['rowNumber'] ?? map['row'] ?? 0;
```

### 4. Duration Fields for Text
Text lessons have both `estimatedReadTime` and `duration`:

```dart
final readTime = map['estimatedReadTime'] ?? map['duration'] ?? 0;
```

### 5. Text Content Format
Handle both Quill Delta JSON and plain text:

```dart
String parseTextContent(String content) {
  try {
    final deltaJson = jsonDecode(content);
    if (deltaJson is List) {
      return Document.fromJson(deltaJson).toPlainText();
    }
  } catch (_) {}
  return content; // Plain text fallback
}
```

### 6. Timestamps
Handle both Firestore Timestamp and ISO 8601 strings:

```dart
DateTime? parseTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {}
  }
  return null;
}
```

---

## Summary

The app now supports 5 lesson types with:
- Full multilingual support (7 languages including English)
- Consistent field naming patterns (`field_{langCode}`)
- Type-based polymorphic rendering via `type` field
- Premium content flagging via `isPremium`
- Duration/time estimation for all content types
- Rich text content for text lessons (Quill Delta JSON)
- Banner images for text lessons (`banner_url`)
- AI-powered automatic translation generation
- Backward compatibility with video-only data

### Quick Reference: Field Naming

| Content | English Field | Translated Pattern |
|---------|---------------|-------------------|
| Lesson Title | `title` | `title_de`, `title_es`, etc. |
| Description | `description` | `description_de`, etc. |
| Text Content | `content` | `content_de`, etc. |
| Quiz Question | `questionText` | `questionText_de`, etc. |
| Quiz Option | `text` | `text_de`, etc. |
| Flashcard Front | `frontText` | `frontText_de`, etc. |
| Flashcard Back | `backText` | `backText_de`, etc. |

### Quick Reference: Storage Keys

| Lesson Type | Banner/Thumbnail | Content Storage |
|-------------|------------------|-----------------|
| Video | `thumbnailUrl` | `videoUrl` (URL) |
| Audio | `thumbnailUrl` | `audioUrl` (URL) |
| Text | `banner_url`, `thumbnailUrl` | `content` (Quill Delta JSON) |
| Quiz | - | `questions` array |
| Flashcard | - | `cards` array |
