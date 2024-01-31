#!/bin/bash

(
    export ASPNETCORE_URLS=http://+:8081
    dotnet api1.dll &
)

(
    export ASPNETCORE_URLS=http://+:8082
    dotnet api2.dll &
)

nginx -g "daemon off;"