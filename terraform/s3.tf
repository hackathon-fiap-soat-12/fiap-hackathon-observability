resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "loki_chunk" {
  bucket = "loki-chunks-${random_id.bucket_suffix.hex}"

  force_destroy = true
}

resource "aws_s3_bucket" "loki_ruler" {
  bucket = "loki-ruler-${random_id.bucket_suffix.hex}"

  force_destroy = true
}

resource "aws_s3_bucket" "tempo" {
  bucket = "tempo-storage-${random_id.bucket_suffix.hex}"

  force_destroy = true
}
