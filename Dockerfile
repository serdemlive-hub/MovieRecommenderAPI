# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY MovieRecommenderAPI/*.csproj ./MovieRecommenderAPI/
RUN dotnet restore MovieRecommenderAPI/MovieRecommenderAPI.csproj

COPY . .
RUN dotnet publish MovieRecommenderAPI/MovieRecommenderAPI.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "MovieRecommenderAPI.dll"]
