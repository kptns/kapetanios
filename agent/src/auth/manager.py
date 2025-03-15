from os import getenv


class AuthManager:
    def __init__(self):
        self.api_key = None

    def __get_api_key(self):
        """
        Get the API key from the environment variables.
        
        Returns:
            str: The API key.
        """
        return getenv("KPTNS_API_KEY")

    def set_api_key(self):
        """
        Set the API key from the environment variables.
        """
        if self.api_key is None:
            self.api_key = self.__get_api_key()
        else:
            raise Exception("API key already set")

    def get_api_key(self) -> str:
        """
        Get the API key.
        
        Returns:
            str: The API key.
        """
        return self.api_key
