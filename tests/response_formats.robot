*** Settings ***
Library          RequestsLibrary
Resource         ../res/variables.resource
Resource         ../res/common_keywords.resource
Test Setup       Start Session For Test
Test Teardown    Delete All Sessions


*** Variables ***
${BROTLI_ENDPOINT}    /brotli
${DEFLATE_ENDPOINT}   /deflate
${DENY_ENDPOINT}      /deny
${ENCODING_UTF8_ENDPOINT}  /encoding/utf8


*** Test Cases ***
API GET Brotli Encoded Data
    ${headers}=     Create Dictionary    Accept-Encoding=br
    ${response}=    Perform GET Request And Verify Status    ${BROTLI_ENDPOINT}    headers=${headers}
    Response Header Should Be    ${response}    Content-Encoding    br
    Response Text Should Not Be Empty    ${response}

API GET Deflate Encoded Data
    ${headers}=     Create Dictionary    Accept-Encoding=deflate
    ${response}=    Perform GET Request And Verify Status    ${DEFLATE_ENDPOINT}    headers=${headers}
    Response Header Should Be    ${response}    Content-Encoding    deflate
    Response Text Should Not Be Empty    ${response}

API GET Deny Encoded Data
    [Tags]    test:retry(2)
    ${headers}=     Create Dictionary    Accept-Encoding=deny
    ${response}=    Perform GET Request And Verify Status    ${DENY_ENDPOINT}    headers=${headers}
    Response Text Should Not Be Empty    ${response}
    Response Header Should Be    ${response}    Content-Type    text/plain

API GET UTF-8 Encoded Data
    ${response}=    Perform GET Request And Verify Status    ${ENCODING_UTF8_ENDPOINT}
    Response Header Should Be    ${response}    Content-Type    text/html; charset=utf-8
    Response Text Should Contain    ${response}    UTF-8 encoded sample plain-text file
