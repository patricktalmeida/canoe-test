FROM python:3.9-slim AS builder
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
RUN useradd -m nonroot
USER nonroot
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
