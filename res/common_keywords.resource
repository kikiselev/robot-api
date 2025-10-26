*** Settings ***
Library      RequestsLibrary
Resource     variables.resource


*** Keywords ***
Start Session For Test
    [Documentation]    Creates a new HTTP session for the test case.
    Create Session    ${SESION}    ${BASE_URL}

Perform ${method} Request And Verify Status
    [Arguments]    ${url}    ${expected_status}=200    &{kwargs}
    ${response}=    Run Keyword    ${method} On Session    ${SESION}    ${url}    &{kwargs}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

Response Header Should Be
    [Arguments]    ${response}    ${header_name}    ${expected_value}
    Should Be Equal As Strings    ${response.headers}[${header_name}]    ${expected_value}

Response Text Should Not Be Empty
    [Arguments]    ${response}
    Should Not Be Empty    ${response.text}

Response Text Should Be
    [Arguments]    ${response}    ${expected_text}
    Should Be Equal As Strings    ${response.text}    ${expected_text}

Response Text Should Contain
    [Arguments]    ${response}    ${expected_substring}
    Should Contain    ${response.text}    ${expected_substring}

Response Content Length Should Be
    [Arguments]    ${response}    ${expected_length}
    ${length}=    Get Length    ${response.content}
    Should Be Equal As Integers    ${length}    ${expected_length}
