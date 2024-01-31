#!/bin/bash

dotnet api1.dll &
dotnet api2.dll &

nginx -g "daemon off;"