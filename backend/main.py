from fastapi import FastAPI

app = FastAPI(title="LEAKLENS API")


@app.get("/")
def root():
    return {"message": "LEAKLENS API is running"}


@app.get("/health")
def health():
    return {"status": "healthy"}