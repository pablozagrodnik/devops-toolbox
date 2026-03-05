# Budowanie aplikacji
FROM node:22-alpine as build

WORKDIR /app

# Kopiowanie list zależności
COPY package*.json ./

# Instalacja zależności
RUN npm install

# Kopiowanie kodu źródłowego
COPY . .

# Argumenty budowania (z GitHub Actions)
ARG VITE_GOOGLE_CLIENT_ID
ENV VITE_GOOGLE_CLIENT_ID=$VITE_GOOGLE_CLIENT_ID

ARG VITE_VAPID_PUBLIC_KEY
ENV VITE_VAPID_PUBLIC_KEY=$VITE_VAPID_PUBLIC_KEY

# Budowanie wersji produkcyjnej
RUN npm run build

# Serwowanie aplikacji
FROM nginx:alpine

# Kopiowanie zbudowanych plików do katalogu Nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

# start ngninx
CMD ["nginx", "-g", "daemon off;"]
