# LEAKLENS

> **The water you can't see.**

LEAKLENS is an AI-assisted water leak detection prototype that turns everyday water-consumption data into an early warning signal for hidden leaks.

It helps users detect suspicious consumption patterns, understand why they may indicate water waste, and identify where to investigate.

---

## The Problem

Hidden water leaks can continuously waste water without being immediately visible.

A user may only discover a problem after receiving an unexpectedly high water bill, when significant amounts of water may already have been wasted.

Traditional consumption data tells users **how much water they used**, but not necessarily **why their consumption looks unusual**.

LEAKLENS aims to bridge that gap.

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
                   │    Web Frontend      │
                   │   HTML / CSS / JS    │
                   └──────────┬───────────┘
                              │
                              │ REST API
                              ▼
                   ┌──────────────────────┐
                   │     FastAPI API      │
                   │       Python         │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
                   │ Diagnostic Engine    │
                   │ Rule-based Heuristic │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
```
