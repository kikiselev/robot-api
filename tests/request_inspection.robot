*** Settings ***
Library          RequestsLibrary
Resource         ../res/variables.resource
Resource         ../res/common_keywords.resource
Test Setup       Start Session For Test
Test Teardown    Delete All Sessions


*** Variables ***
${HEADERS_ENDPOINT}       /headers
${IP_ENDPOINT}            /ip
${USER_AGENT_ENDPOINT}    /user-agent


*** Test Cases ***
API GET Request Returns Headers
    ${response}=    Perform GET Request And Verify Status    ${HEADERS_ENDPOINT}
    Response Header Should Be    ${response}    Content-Type    application/json
    Should Contain    ${response.json()}[headers]    Host

API GET Request Returns Client IP
    ${response}=    Perform GET Request And Verify Status    ${IP_ENDPOINT}
    Should Match Regexp    ${response.json()}[origin]    ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$

API GET Request Returns User-Agent
    ${response}=    Perform GET Request And Verify Status    ${USER_AGENT_ENDPOINT}
    Should Contain    ${response.json()}[user-agent]    python-requests
