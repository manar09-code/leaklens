import os
from typing import Literal

from dotenv import load_dotenv
from google import genai
from google.genai import errors, types
from pydantic import BaseModel, Field

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise RuntimeError("GEMINI_API_KEY is not configured in .env")

client = genai.Client(api_key=GEMINI_API_KEY)

MODEL_NAMES = [
    "gemini-3.6-flash",
    "gemini-3.5-flash",
    "gemini-3.5-flash-lite",
]


class DiagnosticResponse(BaseModel):
    anomaly_detected: bool = Field(
        description="Whether the supplied usage pattern suggests an anomaly."
    )
    severity: Literal["low", "medium", "high"] = Field(
        description="Estimated severity of the anomaly."
    )
    likely_sources: list[str] = Field(
        description="Likely leak or fixture sources based only on supplied data."
    )
    explanation: str = Field(
        description="Concise explanation of the evidence and reasoning."
    )
    recommendation: str = Field(
        description="Practical next action for the user."
    )


def analyze_water_usage(usage_data: dict) -> dict:
    prompt = f"""
You are the explanation layer of LEAKLENS, a hidden water-leak detection
application.

Analyze the following household water-usage information:

{usage_data}

Rules:
- Do not invent measurements or sensor readings.
- Do not invent an anomaly score or probability.
- Treat anomaly_detected, anomaly_score, risk_level, and evidence as
  supplied analytical results, not values you generated yourself.
- Clearly distinguish observed evidence from inference.
- Only identify likely leak sources reasonably supported by the available
  fixture information.
- Return the result using the required structured schema.
"""

    last_error = None

    for model_name in MODEL_NAMES:
        try:
            response = client.models.generate_content(
                model=model_name,
                contents=prompt,
                config=types.GenerateContentConfig(
                    response_mime_type="application/json",
                    response_schema=DiagnosticResponse,
                ),
            )

            if response.parsed is None:
                raise RuntimeError(
                    f"Gemini returned no structured response from {model_name}"
                )

            return response.parsed.model_dump()

        except errors.ServerError as exc:
            last_error = exc
            continue

    if last_error is not None:
        raise last_error

    raise RuntimeError("No Gemini model was available")
