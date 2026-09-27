# LEAKLENS

> **The water you can't see.**

LEAKLENS is an AI-assisted water leak detection prototype that turns everyday water-consumption data into an early warning signal for hidden leaks.

It helps users detect suspicious consumption patterns, understand why they may indicate water waste, estimate potential losses, and identify where to investigate.

> **Hackathon project:** Developed for the **GoMyCode Hackathon 2026** as a functional web and mobile prototype.

---

## The Problem

Hidden water leaks can continuously waste water without being immediately visible.

A user may only discover a problem after receiving an unexpectedly high water bill, when significant amounts of water may already have been wasted.

Traditional consumption data tells users **how much water they used**, but not necessarily **why their consumption looks unusual**.

LEAKLENS aims to bridge that gap by turning simple consumption information into an understandable early warning signal.

---

## The Solution

LEAKLENS analyzes a small set of household water-consumption signals and produces an interpretable diagnostic.

The user provides:

* Monthly water consumption in m³
* Typical usage hours
* Number of fixtures
* Primary fixture

LEAKLENS then analyzes these signals using a **rule-based heuristic diagnostic engine**.

The system provides:

* Leak detection signal
* Confidence score
* Estimated water wasted per day
* Estimated monthly cost
* Suspected fixture
* Explanation of the detected pattern

The goal is not to claim that a leak has been physically confirmed, but to provide an early warning that helps the user investigate potential water waste.

---

## Core User Journey

```text
Enter consumption data
        ↓
Analyze consumption signals
        ↓
Detect suspicious pattern
        ↓
Estimate potential waste
        ↓
Identify suspected fixture
        ↓
Explain the result
        ↓
Help the user take action
```

### Detect → Explain → Act

**Detect**

Identify unusual combinations of consumption and usage patterns.

**Explain**

Show the user why the pattern is considered suspicious.

**Act**

Give the user useful information about potential water waste and where to investigate.

---

## Example

Example input:

```text
Monthly consumption: 40 m³
Usage hours: Night
Number of fixtures: 6
Primary fixture: Toilet
```

Example output:

```text
Leak detected: Yes
Diagnostic confidence: 100%
Estimated water waste: 1,013 L/day
Estimated monthly cost: 18.24 DT
Suspected fixture: Toilet
```

The system also provides an explanation describing the signals that contributed to the diagnostic.

> **Important:** The confidence score is the output of the current diagnostic heuristic. It does not mean that a physical leak has been confirmed with 100% certainty.

---

## Technology Stack

### Web Frontend

* HTML5
* CSS3
* JavaScript

### Mobile Application

* Flutter
* Dart
* Android

### Backend

* Python
* FastAPI
* Pydantic
* REST API

### Data & Development

* MongoDB integration
* Git
* GitHub
* AI-assisted development tools

---

## System Architecture

```text
                         ┌──────────────────────┐
                         │     Web Frontend     │
                         │     HTML / CSS / JS  │
                         └──────────┬───────────┘
                                    │
                                    │ REST / JSON
                                    ▼
                         ┌──────────────────────┐
                         │     Flutter App      │
                         │     Dart / Android   │
                         └──────────┬───────────┘
                                    │
                                    │ REST / JSON
                                    ▼
                         ┌──────────────────────┐
                         │      FastAPI API     │
                         │       Python         │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │  Diagnostic Engine   │
                         │ Rule-based Heuristic │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   Diagnostic Result  │
                         │ Signal / Score /     │
                         │ Waste / Cost /       │
                         │ Fixture / Explanation│
                         └──────────────────────┘
```

The web and Flutter clients use the same backend contract so that the diagnostic logic remains centralized.

---

## API Contract

The main endpoint is:

```http
POST /api/diagnostic
```

### Request

```json
{
  "monthly_usage_m3": 40,
  "usage_hours": ["night"],
  "fixture_count": 6,
  "primary_fixture": "toilet"
}
```

### Response

```json
{
  "leak_detected": true,
  "confidence": 100,
  "estimated_waste_liters_per_day": 1013,
  "estimated_monthly_cost_dt": 18.24,
  "suspected_fixture": "toilet",
  "explanation": "..."
}
```

The same API contract is used by the web integration and Flutter application.

---

## Project Structure

```text
LEAKLENS/
├── frontend/
│   ├── login.html
│   ├── usage.html
│   ├── fixtures.html
│   ├── diagnostic.html
│   ├── results.html
│   ├── settings.html
│   └── js/
│       ├── state.js
│       ├── api.js
│       └── navigation.js
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── schemas.py
│   │   ├── logic.py
│   │   └── config.py
│   ├── services/
│   │   └── telemetry.py
│   └── database.py
│
├── data/
│   ├── generate_sample.py
│   └── sample_usage.csv
│
├── mobile/
│   └── Flutter Android application
│
├── .github/
│   └── workflows/
│       └── deploy-pages.yml
│
├── index.html
├── .gitignore
└── README.md
```

---

# Hackathon Development Process

## 1. Idea Selection

The project started from a simple question:

> **Can everyday water-consumption data provide an early warning for hidden water leaks?**

The team chose this problem because it combines a concrete real-world issue with a data-driven software solution that can be demonstrated within a hackathon timeframe.

The initial concept was narrowed into a focused MVP rather than attempting to build a complete smart-meter platform.

---

## 2. Defining the MVP

The team defined a small, demonstrable user journey:

1. Enter household consumption information.
2. Submit the information to the diagnostic engine.
3. Analyze the combination of signals.
4. Return a leak signal and confidence score.
5. Estimate potential water waste.
6. Estimate potential monthly cost.
7. Identify a suspected fixture.
8. Explain the result.
9. Let the user understand what to investigate next.

This scope was intentionally kept small enough to become a working prototype during the hackathon.

---

## 3. Product and UX Design

The interface was designed around a simple progression rather than a dashboard overloaded with numbers.

The main flow is:

```text
Start
  ↓
Usage information
  ↓
Fixtures
  ↓
Diagnostic
  ↓
Results
  ↓
Explanation / Action
```

The LEAKLENS visual identity uses a blue water-inspired palette and a three-wave logo representing the flow of water.

The tagline is:

> **The water you can't see.**

The web and mobile experiences were designed to follow the same visual language and product flow.

---

## 4. Backend Development

The backend was implemented with **Python and FastAPI**.

The API was designed around a small and stable contract so both clients could consume the same diagnostic service.

The main backend responsibilities are:

* Validate incoming diagnostic data.
* Pass validated data to the diagnostic engine.
* Calculate the diagnostic result.
* Return a structured JSON response.
* Support persistence integration.
* Expose health and service endpoints.

The core diagnostic logic is kept separate from the API layer so that the heuristic can be improved independently.

---

## 5. Diagnostic Engine

The current LEAKLENS engine is **rule-based and heuristic**.

It is not a trained machine-learning model.

The engine combines signals such as:

* Monthly consumption
* Usage during unusual hours
* Number of fixtures
* Primary fixture

These signals contribute to a diagnostic score and the resulting explanation.

This approach was selected because it is:

* Fast to implement during a hackathon.
* Deterministic and reproducible.
* Easy to explain to users and judges.
* Easy to test with controlled scenarios.
* Easier to inspect than an opaque model without a validated dataset.

The architecture leaves room for a future machine-learning or anomaly-detection model once representative labelled data is available.

---

## 6. Web Application

The web prototype was implemented using standard HTML, CSS, and JavaScript.

The frontend contains separate screens for:

* Login
* Usage input
* Fixture information
* Diagnostic
* Results
* Settings

The frontend communicates with the FastAPI backend through the REST API.

The web application was also prepared for GitHub Pages deployment using GitHub Actions.

---

## 7. Flutter Mobile Application

A Flutter application was developed to provide the same core experience on Android.

The mobile application includes:

* Login / signup interface
* Usage input
* Fixture selection
* Diagnostic flow
* Results screen
* API integration

The Flutter app communicates with the same `/api/diagnostic` endpoint used by the web application.

A release Android APK was generated as part of the hackathon prototype.

---

## 8. Data and Testing

Because the hackathon prototype does not have access to a large labelled real-world leak dataset, development and testing use manually defined and synthetic consumption scenarios.

A representative test scenario is:

```text
40 m³/month
Nighttime usage
6 fixtures
Primary fixture: Toilet
```

The expected prototype behavior is a strong leak signal with estimated waste and cost information.

Testing focused on:

* API request validation.
* API response structure.
* Web-to-API integration.
* Flutter-to-API integration.
* Diagnostic calculation consistency.
* UI navigation.
* Release APK generation.
* End-to-end demonstration flow.

---

## 9. API Integration Testing

The integration was tested by sending real requests to the FastAPI endpoint and checking that the clients correctly display the returned response.

The intended integration chain is:

```text
User input
    ↓
Web / Flutter client
    ↓
POST /api/diagnostic
    ↓
FastAPI
    ↓
Diagnostic engine
    ↓
JSON response
    ↓
Results interface
```

Keeping this contract identical across clients reduces duplicated business logic and makes future maintenance easier.

---

## 10. Deployment

The web prototype was prepared for deployment through **GitHub Pages**.

The repository includes a GitHub Actions workflow that prepares the static frontend and deploys it as a Pages artifact.

The project is intended to be accessible through:

**https://manar09-code.github.io/leaklens/**

The public frontend and backend are separate deployment concerns because GitHub Pages hosts static content and does not run the FastAPI server.

The prototype can therefore be demonstrated locally with the backend while the web interface is hosted as a static site.

---

# AI Contribution

## AI Inside the Product

LEAKLENS currently uses an **interpretable rule-based heuristic diagnostic engine**, rather than a trained machine-learning model.

User inputs are processed by the diagnostic logic to produce:

* Leak signal
* Confidence score
* Estimated waste
* Estimated monthly cost
* Suspected fixture
* Explanation

The design deliberately prioritizes interpretability so users can understand why the system produced a warning.

---

## AI Used During Development

The team used AI coding and content assistants during development for tasks such as:

* Exploring implementation approaches.
* Generating and refining code suggestions.
* Debugging.
* Reviewing implementation ideas.
* Improving documentation.
* Assisting with UI and content wording.
* Preparing presentation and communication material.

AI-generated suggestions were reviewed, tested, modified, and integrated by the team rather than being used blindly.

The final implementation decisions and testing remained the responsibility of the team.

### Brev Disclosure

**NVIDIA Brev was not used in the development of LEAKLENS.**

---

# Sources and Development References

The project was developed using official documentation, standard developer tools, and technical references.

### Core Technologies

* [Python Documentation](https://docs.python.org/3/)
* [FastAPI Documentation](https://fastapi.tiangolo.com/)
* [Pydantic Documentation](https://docs.pydantic.dev/)
* [Flutter Documentation](https://docs.flutter.dev/)
* [Dart Documentation](https://dart.dev/)
* [Android Developers](https://developer.android.com/)
* [MDN Web Docs](https://developer.mozilla.org/)
* [Git Documentation](https://git-scm.com/doc)
* [GitHub Documentation](https://docs.github.com/)
* [GitHub Pages Documentation](https://docs.github.com/en/pages)
* [MongoDB Documentation](https://www.mongodb.com/docs/)

### Hackathon

LEAKLENS was developed for the **GoMyCode Hackathon 2026**.

The project was shaped around the hackathon requirements, including:

* Functional prototype.
* Working user experience.
* AI/tool disclosure.
* Technical explanation.
* Demonstration video.
* Project presentation.
* Source-code submission.
* Testing and limitations.
* Responsible AI and data considerations.

---

# Development Tools

The team used a conventional software-development workflow supported by:

* Visual Studio Code
* Android Studio
* Flutter SDK
* Python
* FastAPI
* Git
* GitHub
* GitHub Actions
* Android build tools
* API testing tools
* AI-assisted development tools

The repository was used as the central source of truth for the project code and documentation.

---

# Team Workflow

The project was developed as a two-person hackathon team.

### Frontend, Mobile & Integration

**Manar Degachi**

Focus areas:

* Flutter mobile application
* Android APK
* API integration
* Web/frontend integration
* UI/UX implementation
* Testing and device validation
* Presentation preparation
* Product demonstration

### Backend, AI & Data

**Eya**

Focus areas:

* FastAPI backend
* Diagnostic engine
* Data and logic
* API structure
* Backend integration
* AI/heuristic implementation

Both team members contributed to:

* Product definition
* MVP decisions
* Testing
* Pitch preparation
* Business Model Canvas
* Hackathon presentation

---

# Hackathon Deliverables

The project was prepared around the main hackathon submission requirements.

### Prototype

A working LEAKLENS web and Android prototype.

### Backend

FastAPI REST API exposing the diagnostic endpoint.

### Demo

A short product demonstration showing the problem, user input, diagnostic process, and resulting explanation.

### Project Documentation

This repository documents:

* The problem.
* The solution.
* Architecture.
* Technology stack.
* Development process.
* AI contribution.
* Testing.
* Limitations.
* Future development.

### Source Code

Repository:

**https://github.com/manar09-code/leaklens**

### Web Prototype

**https://manar09-code.github.io/leaklens/**

---

# Testing Results

A representative scenario was successfully used to demonstrate the complete diagnostic flow:

| Input | Value |
|---|---|
| Monthly consumption | 40 m³ |
| Usage period | Night |
| Fixtures | 6 |
| Primary fixture | Toilet |
| Leak signal | Detected |
| Diagnostic score | 100% |
| Estimated waste | 1,013 L/day |
| Estimated monthly cost | 18.24 DT |

The API integration was tested with the web and Flutter flows using the same request and response structure.

---

# Current Prototype Status

### Working

* Web user interface
* Flutter Android application
* FastAPI backend
* REST API integration
* Rule-based diagnostic engine
* Diagnostic results
* Explanations
* Estimated water waste
* Estimated monthly cost
* Suspected fixture identification
* GitHub repository
* GitHub Pages deployment workflow
* Android release APK

### Prototype / Development Stage

* MongoDB persistence integration
* Public backend deployment
* Extended real-world validation

---

# Limitations

LEAKLENS is a hackathon prototype and should not be interpreted as a certified leak-detection system.

Current limitations include:

* The diagnostic engine is heuristic rather than trained on a large labelled dataset.
* The current prototype uses synthetic/manual consumption scenarios.
* A diagnostic result is an early warning, not physical confirmation of a leak.
* Continuous smart-meter monitoring is not implemented.
* Automated alerts are not implemented.
* Real-world accuracy has not yet been established across a representative population.
* The public GitHub Pages frontend requires a separately deployed backend for fully public end-to-end API functionality.

These limitations are intentional and define the next stage of development rather than being hidden from users.

---

# Responsible AI & Data

The current prototype is designed with interpretability in mind.

* No private personal dataset is required for the core diagnostic.
* Development scenarios are manually defined or synthetic.
* The system does not present its heuristic result as proof of a physical leak.
* The explanation helps users understand the signals behind the result.
* No passwords, API keys, or private credentials are included in the repository.
* Future versions should use representative datasets and appropriate privacy safeguards.
* Any future machine-learning model should be evaluated against labelled real-world data before being used for high-confidence decisions.

---

# Future Development

The next versions of LEAKLENS could expand the prototype into a continuous monitoring platform.

### Data

* Larger real-world consumption datasets.
* Labelled leak and non-leak scenarios.
* Historical household consumption profiles.

### AI / Analytics

* Statistical anomaly detection.
* Time-series analysis.
* Machine-learning models trained on representative data.
* Personalized household baselines.
* Improved confidence calibration.

### IoT

* Smart-meter integration.
* Real-time consumption monitoring.
* Automated anomaly detection.
* Continuous monitoring.

### User Experience

* Push notifications.
* Historical consumption charts.
* Leak-event timeline.
* Personalized recommendations.
* Household profiles.

### Platform

* Production backend deployment.
* Scalable database architecture.
* Authentication and secure user accounts.
* Monitoring and observability.
* Production security controls.

---

# What We Would Build Next

The logical next version of LEAKLENS would move from a **single diagnostic interaction** toward **continuous household monitoring**:

```text
Smart Meter / IoT Data
        ↓
Continuous Data Collection
        ↓
Household Baseline
        ↓
Anomaly Detection
        ↓
Leak Risk Assessment
        ↓
Explanation
        ↓
Alert
        ↓
User Action
```

This would allow LEAKLENS to detect changes over time rather than relying only on manually entered consumption values.

---

# Repository

**GitHub:**  
https://github.com/manar09-code/leaklens

**Web Prototype:**  
https://manar09-code.github.io/leaklens/

---

# Hackathon Context

LEAKLENS was created during the **GoMyCode Hackathon 2026** as a rapid prototype built around the idea of using AI-assisted software and interpretable data analysis to address a practical environmental problem.

The project demonstrates the complete path from:

```text
Problem
  ↓
Idea
  ↓
MVP Definition
  ↓
UX Design
  ↓
Backend
  ↓
Diagnostic Logic
  ↓
Web Integration
  ↓
Flutter Application
  ↓
Testing
  ↓
Deployment
  ↓
Demo & Presentation
```

The objective was not to build a finished commercial platform in hackathon time.

The objective was to prove the concept with a functional, understandable, and demonstrable prototype while clearly documenting what works today, what remains experimental, and what would be required to make the system production-ready.

---

## License

This project was created as a hackathon prototype. See the repository for the applicable licensing information.
