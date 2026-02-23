---

## ⁠ lambda/handler.py ⁠
```python
import os
import logging
from datetime import datetime, timezone, timedelta

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")

def handler(event, context):
    retention_days = int(os.getenv("RETENTION_DAYS", "365"))
    dry_run = os.getenv("DRY_RUN", "true").lower() in ("1", "true", "yes")

    cutoff = datetime.now(timezone.utc) - timedelta(days=retention_days)
    logger.info(f"Retention days: {retention_days}, cutoff: {cutoff.isoformat()}, dry_run: {dry_run}")

    deleted = 0
    scanned = 0
    skipped = 0
    errors = 0

    paginator = ec2.get_paginator("describe_snapshots")
    for page in paginator.paginate(OwnerIds=["self"]):
        for snap in page.get("Snapshots", []):
            scanned += 1
            snap_id = snap.get("SnapshotId")
            start_time = snap.get("StartTime")

            if not start_time or start_time >= cutoff:
                skipped += 1
                continue

            logger.info(f"Candidate: {snap_id} start_time={start_time.isoformat()}")

            if dry_run:
                logger.info(f"[DRY_RUN] Would delete: {snap_id}")
                continue

            try:
                ec2.delete_snapshot(SnapshotId=snap_id)
                deleted += 1
                logger.info(f"Deleted: {snap_id}")
            except ClientError as e:
                errors += 1
                logger.error(f"Failed to delete {snap_id}: {e}", exc_info=True)

    return {
        "scanned": scanned,
        "deleted": deleted,
        "skipped": skipped,
        "errors": errors,
        "retention_days": retention_days,
        "dry_run": dry_run,
    }
