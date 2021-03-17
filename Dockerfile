# https:hub.docker.com/ _/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build 
WORKDIR /APP

# copy csproj and restore as distinct layers
COPY src/com.teamfu.be/storbe/storbe.csproj ./
RUN dotnet restore storbe.csproj

# copy everything else and build app 
COPY src/com.teamfu.be/storebe/. /app/storebe
WORKDIR /app/storebe
RUN mkdir /publishedApp
RUN dotnet publish storbe.csproj -c release -o /publishedApp

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /publishedApp .
ENTRYPOINT [ "dotnet", "storbe.dll"]