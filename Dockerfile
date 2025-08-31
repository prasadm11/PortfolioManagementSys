# =========================
# 1. Build stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY PortfolioManamagement.API/*.csproj PortfolioManamagement.API/
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR /src/PortfolioManamagement.API
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# =========================
# 2. Runtime stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

# Copy published output
COPY --from=build /app/publish .

# Expose port
EXPOSE 5000
EXPOSE 5001

# Run the app
ENTRYPOINT ["dotnet", "PortfolioManamagement.API.dll"]
