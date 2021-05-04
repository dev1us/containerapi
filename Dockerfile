# Get base runtime from Microsoft
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000

# Get base sdk image from Microsoft
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

# Copy source code to 
COPY ["containerapi.csproj", "./"]
RUN dotnet restore "containerapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "containerapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "containerapi.csproj" -c Release -o /app/publish

# Generate runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "containerapi.dll"]
