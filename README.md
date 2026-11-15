# Servicio web de reserva de horas médicas — Proyecto DevOps integrador

Proyecto académico (IACC 2026) que simula el servicio web de reserva de horas médicas de una empresa del rubro salud (**Centro Médico Vida Sana**, nombre ficticio). Es una **aplicación web estática** servida con **Nginx** dentro de un contenedor **Docker** y levantada con **Docker Compose** en el puerto **8080**.

> ⚠️ Entorno de simulación: el formulario **no envía ni almacena datos**. No hay API ni base de datos. No ingrese datos personales reales.

## Problema que resuelve

El equipo de operaciones instalaba archivos a mano, configuraba variables y reiniciaba servicios fuera de horario. Las versiones funcionaban en el PC del desarrollador y fallaban en pruebas por diferencias de dependencias, rutas, puertos o configuraciones. Este proyecto aplica prácticas DevOps:

| Problema | Práctica aplicada |
|---|---|
| Diferencias entre entornos | Imagen Docker con `nginx:alpine` (mismo entorno en cualquier equipo) |
| Instalación manual | `docker compose up -d --build` levanta todo con un comando |
| Configuración dispersa | Variables en `.env` (local) documentadas en `.env.example` |
| Falta de trazabilidad | Git + GitHub: commits descriptivos, ramas y pull requests |
| Riesgo de exponer datos | `.gitignore` excluye `.env`, claves y logs; sin datos reales |
| Validación manual | GitHub Actions (`devopsautomation.yml`) valida y prueba cada cambio |

## Estructura del proyecto

```
proyecto-devops-reserva-horas/
├── .github/
│   └── workflows/
│       └── devopsautomation.yml   # Automatización complementaria (CI)
├── src/
│   ├── index.html                 # Formulario de reserva, datos de atención y estado del servicio
│   └── styles.css                 # Hoja de estilos
├── .env.example                   # Variables de ejemplo (sin secretos)
├── .gitignore                     # Archivos excluidos del repositorio
├── docker-compose.yml             # Servicio "web" publicado en el puerto 8080
├── Dockerfile                     # Imagen basada en nginx:alpine
└── README.md
```

## Requisitos

- Git
- Docker Desktop iniciado ("Engine running")
- Navegador web

## Instalación

```bash
git clone https://github.com/USUARIO/proyecto-devops-reserva-horas.git
cd proyecto-devops-reserva-horas
```

Crear el archivo de variables local a partir del ejemplo:

```bash
# Windows (CMD)
copy .env.example .env
# Linux / macOS / Git Bash
cp .env.example .env
```

## Ejecución

```bash
docker compose up -d --build
```

## Verificación

| Acción | Comando / URL | Resultado esperado |
|---|---|---|
| Ver contenedor | `docker compose ps` | `reserva-horas-web` en estado *Up (healthy)* |
| Abrir el sitio | http://localhost:8080 | Formulario de reserva de horas médicas |
| Ver logs | `docker compose logs web` | Peticiones `GET /` con código 200 |
| Ver métricas | `docker stats reserva-horas-web --no-stream` | Uso de CPU y memoria del contenedor |
| Ver imagen | `docker images reserva-horas-web` | Imagen `reserva-horas-web:1.0.0` |

## Detener el servicio

```bash
docker compose down
```

## Seguridad

- No se versionan credenciales, tokens, claves ni el archivo `.env` (ver `.gitignore`).
- `.env.example` solo contiene valores de ejemplo, sin secretos.
- El sitio no recolecta ni guarda información; todos los datos mostrados son ficticios.
- Se usa una imagen base oficial y liviana (`nginx:alpine`) para reducir la superficie de ataque.
- El contenedor incluye un `HEALTHCHECK` para monitorear su estado.

## Flujo de trabajo con Git

- Rama principal: `main` (versión estable).
- Cambios nuevos en ramas `feature/...` que se integran a `main` mediante pull request.
- Mensajes de commit descriptivos con prefijos: `feat:`, `docs:`, `build:`, `ci:`, `fix:`.

## Automatización (complementaria)

El workflow `.github/workflows/devopsautomation.yml` se ejecuta en cada push o pull request a `main`: verifica la estructura del proyecto, confirma que no exista un `.env` versionado, construye y levanta el servicio con Docker Compose, prueba la respuesta HTTP en el puerto 8080, muestra los logs y limpia los recursos. No publica la aplicación en servidores externos.
