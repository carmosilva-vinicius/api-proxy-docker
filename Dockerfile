FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["api1/api1/api1.csproj", "api1/"]
COPY ["api2/api2/api2.csproj", "api2/"]
RUN dotnet restore "api1/api1.csproj"
RUN dotnet restore "api2/api2.csproj"
COPY . .
WORKDIR "/src/api1"
RUN dotnet build -c Release -o /app/build
WORKDIR "/src/api2"
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false


FROM base AS final
EXPOSE 80
RUN apt-get update && apt-get install -y nginx

WORKDIR /app
COPY --from=publish /app/publish .

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./scripts/run.sh run.sh
RUN ["chmod", "+x", "run.sh"]
ENTRYPOINT ["/bin/sh","run.sh"]