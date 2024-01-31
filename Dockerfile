FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /apps
EXPOSE 80 8081 8082

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["api1/api1/api1.csproj", "api1/"]
COPY ["api2/api2/api2.csproj", "api2/"]
RUN dotnet restore "api1/api1.csproj"
RUN dotnet restore "api2/api2.csproj"
COPY . .
WORKDIR "/src/api1"
RUN dotnet build -c Release -o /apps/build
WORKDIR "/src/api2"
RUN dotnet build -c Release -o /apps/build

FROM build AS publish
WORKDIR "/src/api1"
RUN dotnet publish -c Release -o /apps/publish /p:UseAppHost=false
WORKDIR "/src/api2"
RUN dotnet publish -c Release -o /apps/publish /p:UseAppHost=false

FROM base AS final
RUN apt-get update && apt-get install -y nginx

WORKDIR /apps
COPY --from=publish /apps/publish .
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./scripts/run.sh run.sh

RUN ["chmod", "+x", "run.sh"]
ENTRYPOINT ["/bin/sh","run.sh"]