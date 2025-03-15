# Python tools
import logging
from typing import Union


class LoggerError(Exception):
    def __init__(self):
        pass


class LogManager:
    def __init__(self, name):
        self.name = name
        self.logger = None
        self.file_handler = None
        self.stream_handler = None
        self.handlers = list()

    def _set_level(self):
        self.logger.setLevel(logging.INFO)

    def _get_formart(self):
        return logging.Formatter(
            "%(asctime)s - %(levelname)s - %(message)s", datefmt="%Y-%m-%d %H:%M:%S"
        )

    def _set_file_handler(self):
        if self.file_handler is None:
            self.file_handler = logging.FileHandler(f"{self.name}.log")
            self.file_handler.setFormatter(self._get_formart())
            self.handlers.append(self.file_handler)

    def _set_stream_handler(self):
        if self.stream_handler is None:
            self.stream_handler = logging.StreamHandler()
            self.stream_handler.setFormatter(self._get_formart())
            self.handlers.append(self.stream_handler)

    def _create_logger(self):
        if self.logger is None:
            self.logger = logging.getLogger(self.name)

    def _add_handler(self, handler: Union[logging.StreamHandler, logging.FileHandler]):
        if self.logger is not None:
            self.logger.addHandler(handler)

    def init(self):
        try:
            self._create_logger()
            self._set_level()
            self._set_file_handler()
            self._set_stream_handler()

            for handler in self.handlers:
                self._add_handler(handler)

            return self.logger

        except Exception as e:
            raise LoggerError(f"Something failed in Logger: {e}")
