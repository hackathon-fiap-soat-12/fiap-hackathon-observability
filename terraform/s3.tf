resource "aws_s3_bucket" "loki_chunk" {
  bucket = "loki-chunks-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}

resource "aws_s3_bucket" "tempo" {
  bucket = "tempo-storage-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}
