import os
import pytest
from unittest.mock import patch, MagicMock
from src.main import lambda_handler

@pytest.fixture
def mock_env_api_key():
    os.environ["ANTHROPIC_API_KEY"] = "test_api_key"
    yield
    del os.environ["ANTHROPIC_API_KEY"]

@patch("src.main.anthropic.Anthropic")
def test_lambda_handler_success(mock_anthropic, mock_env_api_key):
    # Mock the response from the API
    mock_client = MagicMock()
    mock_client.messages.create.return_value = MagicMock(content=[MagicMock(text="Why did the scarecrow win an award? Because he was outstanding in his field!")])
    mock_anthropic.return_value = mock_client

    # Call the lambda_handler function
    event = {}
    context = {}
    response = lambda_handler(event, context)

    # Assertions
    assert response["statusCode"] == 200
    assert "Why did the scarecrow win an award?" in response["body"]

@patch("src.main.anthropic.Anthropic")
def test_lambda_handler_no_api_key(mock_anthropic):
    # Ensure the environment variable is not set
    if "ANTHROPIC_API_KEY" in os.environ:
        del os.environ["ANTHROPIC_API_KEY"]

    # Call the lambda_handler function and expect a ValueError
    event = {}
    context = {}
    with pytest.raises(ValueError, match="Please set the ANTHROPIC_API_KEY environment variable."):
        lambda_handler(event, context)

@patch("src.main.anthropic.Anthropic")
def test_lambda_handler_api_error(mock_anthropic, mock_env_api_key):
    # Mock the API client to raise an exception
    mock_client = MagicMock()
    mock_client.messages.create.side_effect = Exception("API error")
    mock_anthropic.return_value = mock_client

    # Call the lambda_handler function and expect an exception
    event = {}
    context = {}
    with pytest.raises(Exception, match="API error"):
        lambda_handler(event, context)