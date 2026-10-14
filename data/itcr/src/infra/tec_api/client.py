"""Base API client for TEC Digital services."""

from typing import Any

import requests


class APIClient:
    """Base client for making HTTP requests to TEC Digital APIs."""

    base_url: str = "https://tecdigital.tec.ac.cr"

    def __init__(self) -> None:
        self.session = requests.Session()

    def get(self, endpoint: str, **kwargs: Any) -> Any:
        """Perform a GET request."""
        url = f"{self.base_url}/{endpoint.lstrip('/')}"
        response = self.session.get(url, **kwargs)
        response.raise_for_status()
        return response

    def post(self, endpoint: str, **kwargs: Any) -> Any:
        """Perform a POST request."""
        url = f"{self.base_url}/{endpoint.lstrip('/')}"
        response = self.session.post(url, **kwargs)
        response.raise_for_status()
        return response

    def close(self) -> None:
        """Close the session."""
        self.session.close()
