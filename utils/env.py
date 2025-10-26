import os
from dotenv import load_dotenv
from dataclasses import dataclass


load_dotenv()


@dataclass
class Environment:
    BASE_URL: str


def get_environment() -> Environment:
    if env := os.getenv("BASE_URL", None):
        return Environment(BASE_URL=env)
    else:
        raise Exception("BASE_URL is not set in the environment variables.")


environment = get_environment()


env_vars = {"BASE_URL": environment.BASE_URL}


def get_variables():
    return {**env_vars}
