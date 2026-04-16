# 🪢 Lazo Millonario — Setup Guide

Tu app de entrenamiento mental, con sync automático en la nube.

---

## ¿Qué necesitas?

- Una cuenta en **GitHub** (gratis) → [github.com](https://github.com)
- Una cuenta en **Supabase** (gratis) → [supabase.com](https://supabase.com)

---

## Paso 1 — Crear el repositorio en GitHub

1. Ve a [github.com/new](https://github.com/new)
2. Nombre del repo: `lazo-millonario` (o el que quieras)
3. Marca **Private** si quieres que sea privado
4. Haz clic en **Create repository**
5. En tu computadora, abre una terminal en la carpeta `lazo-millonario/` y ejecuta:

```bash
git init
git add .
git commit -m "Lazo Millonario - primer commit"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/lazo-millonario.git
git push -u origin main
```

> Reemplaza `TU-USUARIO` con tu nombre de usuario de GitHub.

---

## Paso 2 — Crear el proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y haz clic en **Start your project**
2. Crea una organización (o usa una existente)
3. Crea un nuevo proyecto:
   - **Name:** lazo-millonario
   - **Database Password:** elige una contraseña segura (guárdala)
   - **Region:** South America (São Paulo) — la más cercana
4. Espera ~2 minutos a que el proyecto se inicialice

---

## Paso 3 — Crear la tabla en Supabase

1. En tu proyecto de Supabase, ve a **SQL Editor** (ícono de base de datos)
2. Haz clic en **New query**
3. Pega este SQL y haz clic en **Run**:

```sql
-- Tabla de datos de Lazo Millonario
CREATE TABLE lazo_data (
  key TEXT PRIMARY KEY,
  value JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Política de acceso público (app personal, sin autenticación)
ALTER TABLE lazo_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations" ON lazo_data
  FOR ALL USING (true) WITH CHECK (true);
```

4. Deberías ver el mensaje: `Success. No rows returned`

---

## Paso 4 — Copiar tus credenciales

1. En Supabase, ve a **Settings** → **API**
2. Copia los dos valores que necesitas:
   - **Project URL** → algo como `https://abcdefghij.supabase.co`
   - **anon / public** key → una cadena larga que empieza con `eyJ...`

---

## Paso 5 — Pegar las credenciales en index.html

1. Abre `index.html` en cualquier editor de texto
2. Busca estas dos líneas cerca del final del archivo (en la sección `<script>`):

```javascript
const SUPABASE_URL = '';   // ej: https://abcdefghij.supabase.co
const SUPABASE_KEY = '';   // anon / public key
```

3. Reemplázalas con tus valores:

```javascript
const SUPABASE_URL = 'https://TU-PROJECT-ID.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

4. Guarda el archivo

---

## Paso 6 — Subir los cambios a GitHub

```bash
git add index.html
git commit -m "Agrega credenciales Supabase"
git push
```

---

## Paso 7 — Activar GitHub Pages

1. Ve a tu repo en GitHub
2. Haz clic en **Settings** (engranaje)
3. En el menú izquierdo, haz clic en **Pages**
4. En **Source**, selecciona **Deploy from a branch**
5. En **Branch**, selecciona `main` y la carpeta `/root`
6. Haz clic en **Save**
7. Espera 1-2 minutos

Tu app estará disponible en:
```
https://TU-USUARIO.github.io/lazo-millonario/
```

---

## ¿Cómo funciona la sincronización?

- **Local-first:** Cada vez que guardas algo, se guarda inmediatamente en tu dispositivo (localStorage). Luego, en segundo plano, se sincroniza con Supabase.
- **Multi-dispositivo:** Cuando abres la app en otro dispositivo (celular, otra computadora), al cargar descarga automáticamente todos tus datos de Supabase.
- **Sin internet:** La app funciona completamente sin internet. Cuando recuperes la conexión, los cambios se sincronizan solos.
- **Chip de estado:** El chip en la cabecera muestra: `☁️ Sincronizado`, `🔄 Sincronizando…`, `⚠️ Error sync`, o `💾 Solo local`.

---

## Actualizar la app en el futuro

Si modificas `index.html` y quieres que GitHub Pages se actualice:

```bash
git add index.html
git commit -m "Actualización"
git push
```

GitHub Pages se actualiza automáticamente en 1-2 minutos.

---

## Solución de problemas

**La app muestra "⚠️ Error sync"**
- Verifica que copiaste correctamente la URL y la anon key de Supabase
- Asegúrate de que la tabla `lazo_data` existe (Paso 3)
- Abre la consola del navegador (F12) para ver el error exacto

**Los datos no aparecen en otro dispositivo**
- Abre la pestaña **Nube** y haz clic en **⬇️ Traer de la nube**
- Verifica que ambos dispositivos usen la misma URL de la app

**Quiero hacer un backup de mis datos**
- En la pestaña **Nube**, sección **Backup manual**, haz clic en **Generar código**
- Copia ese código y guárdalo en un lugar seguro (notas, email, etc.)

---

## Seguridad

La **anon key** de Supabase es segura para usar en el frontend — está diseñada para ser pública. No es lo mismo que tu contraseña o la service role key. El acceso a la tabla está controlado por las políticas de Row Level Security que configuraste en el Paso 3.

Si quieres más seguridad, puedes agregar autenticación con email/contraseña de Supabase Auth (requiere modificar el código).
