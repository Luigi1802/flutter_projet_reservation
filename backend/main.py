from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.router import user_router, planning_router, reservation_router

app = FastAPI(title="Pizzeria Peppe API", version="1.0.0")

# Autoriser toutes les origines (développement seulement)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # toutes les origines
    allow_credentials=True,
    allow_methods=["*"],  # GET, POST, PUT, DELETE, OPTIONS…
    allow_headers=["*"],  # Content-Type, Authorization, etc.
)

# Inclure les routers
app.include_router(user_router.router)
app.include_router(planning_router.router)
app.include_router(reservation_router.router)

@app.get("/")
def read_root():
    return {"message": "Pizzeria Peppe"}
