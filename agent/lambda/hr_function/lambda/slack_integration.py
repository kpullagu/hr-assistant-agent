# Sends a Slack message, this is a stub that returns a dummy value.
# You can implement this stub by creating a Slack hook, then post message to the Slack hook endpoint.
def send_slack_message(message: str) -> dict:
    return {"status": True}
# Sends a Slack message, this is a stub that returns a dummy value.
# You can implement this stub by creating a Slack hook, then post message to the Slack hook endpoint.
from botocore.vendored import requests
from aws_lambda_powertools import Logger
logger = Logger()
def send_slack_message(message: str) -> bool:
    url = "https://hooks.slack.com/services/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"
    req_json = {"msg": message}
    try:
        requests.post(url, json=req_json)
        return True
    except Exception as e:
        logger.error(f"Error sending message: {e}")
        return False


# def send_slack_message(message: str) -> dict:
#     return {"status": True}