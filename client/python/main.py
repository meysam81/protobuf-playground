import logging
import os
from app.logger import get_logger

logger = get_logger(__name__)

if __name__ == "__main__":
    logger.info("Starting client ...")

    from app.client import run

    run()
