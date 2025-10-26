# Robot Framework REST API Testing

This project demonstrates API testing using Robot Framework.

## Table of Contents
- [Local Environment Setup](#local-environment-setup)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Generating and Viewing Reports](#generating-and-viewing-reports)

## Local Environment Setup

To set up the project locally, follow these steps:

1.  **Prerequisites:**
    *   Ensure you have Python installed (version specified in `.python-version` if available, otherwise Python 3.8+).
    *   Install `uv` (a fast Python package installer and resolver):
        ```bash
        pip install uv
        ```

2.  **Install Dependencies:**
    Navigate to the project root directory and install the required dependencies using `uv`:
    ```bash
    uv sync
    ```

## Configuration

This project uses a `.env` file to manage environment-specific variables.

1.  **Create `.env` file:**
    Create a file named `.env` in the root directory of the project.

2.  **Define Environment Variables:**
    Add the necessary environment variables to the `.env` file. A crucial variable is `BASE_URL`, which specifies the base URL for the API endpoints under test.

    Example `.env` file:
    ```
    BASE_URL=https://api.example.com
    ```
    **Note:** The `BASE_URL` is mandatory for the tests to run correctly.

## Running Tests

Tests can be run using `robot` or `pabot` (for parallel execution). It is recommended to use `pabot` for faster execution.

To run all tests:

```bash
uv run pabot --testlevelsplit --listener RetryFailed --outputdir report tests/
```

This command will execute all test suites located in the `tests/` directory and place the output files in the `report/` directory.

To run specific test:

```bash
uv run robot --outputdir report tests/mytest.robot
```

## Generating and Viewing Reports

After running the tests, Robot Framework automatically generates detailed reports and logs.

1.  **Reports Location:**
    All generated reports and logs are stored in the `report/` directory.
