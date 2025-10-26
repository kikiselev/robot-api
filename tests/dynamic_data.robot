*** Settings ***
Library         RequestsLibrary
Library         FakerLibrary
Library         DateTime
Library         OperatingSystem
Resource        ../res/variables.resource
Resource         ../res/common_keywords.resource
Test Setup       Start Session For Test
Test Teardown    Delete All Sessions


*** Variables ***
${BASE64_ENDPOINT}    /base64
${BYTES_ENDPOINT}     /bytes
${DELAY_ENDPOINT}     /delay
${DRIP_ENDPOINT}      /drip


*** Test Cases ***
API Decodes Base64 String
    ${plain_text}=      Word
    ${encoded_text}=    Evaluate    base64.b64encode(b'${plain_text}').decode('utf-8')    base64
    ${response}=        Perform GET Request And Verify Status    ${BASE64_ENDPOINT}/${encoded_text}
    Response Text Should Be    ${response}    ${plain_text}

API Returns N Random Bytes
    ${num_bytes}=    Random Int  min=50  max=100
    ${response}=     Perform GET Request And Verify Status    ${BYTES_ENDPOINT}/${num_bytes}
    Response Header Should Be    ${response}    Content-Type    application/octet-stream
    Response Content Length Should Be    ${response}    ${num_bytes}

API Returns Predictable Bytes With Seed
    ${n}=      Random Int    min=1    max=32
    ${seed}=   Random Int    min=0    max=1000
    ${response1}=    Perform GET Request And Verify Status    ${BYTES_ENDPOINT}/${n}    params=seed=${seed}
    ${response2}=    Perform GET Request And Verify Status    ${BYTES_ENDPOINT}/${n}    params=seed=${seed}
    Should Be Equal    ${response1.content}    ${response2.content}

    ${response3}=    Perform GET Request And Verify Status    ${BYTES_ENDPOINT}/${n}    params=seed=${seed + 1}
    Should Not Be Equal    ${response3.content}    ${response1.content}

API Returns Delayed Response
    [Template]    Verify Delayed Response
    DELETE
    PUT
    POST
    GET
    PATCH

Verify Drip Endpoint With Delay And Duration
    ${delay}=       Random Int    min=1    max=3
    ${duration}=    Random Int    min=1    max=3
    ${start_time}=    Get Current Date    result_format=%s
    ${response}=      Perform GET Request And Verify Status    ${DRIP_ENDPOINT}    params=delay=${delay}&duration=${duration}
    ${end_time}=      Get Current Date    result_format=%s
    Response Text Should Not Be Empty    ${response}
    ${elapsed_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${elapsed_time} >= ${delay}
    ...    The request should take at least ${delay} seconds. Actual time: ${elapsed_time} seconds.

Verify Drip Endpoint With Custom Code
    ${response}=      Perform GET Request And Verify Status    ${DRIP_ENDPOINT}    201    params=code=201
    Response Text Should Not Be Empty    ${response}


*** Keywords ***
Verify Delayed Response
    [Arguments]    ${method}
    ${delay}=     Random Int    min=1    max=3
    ${response}=    Perform ${method} Request And Verify Status    ${DELAY_ENDPOINT}/${delay}
    ${elapsed_time}=    Set Variable    ${response.elapsed.total_seconds()}
    Should Be Equal As Numbers    ${elapsed_time}    ${delay}    precision=0.5
