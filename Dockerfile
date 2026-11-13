FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/tonie_management.py .
ENV PYTHONUNBUFFERED=1
EXPOSE 8095
CMD ["python3", "tonie_management.py"]
