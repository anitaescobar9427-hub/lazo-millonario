-- ════════════════════════════════════════
-- VAQUERÍA PRO — Schema Supabase
-- Ejecutar completo en: SQL Editor → New Query
-- ════════════════════════════════════════

create extension if not exists "pgcrypto";

-- ── COMPETENCIAS (calendario + ediciones del usuario) ──
create table if not exists competencias (
  id text primary key,
  nombre text not null,
  fecha_inicio date not null,
  fecha_fin date not null,
  lugar text,
  tipo text,
  asistencia text default 'pen' check (asistencia in ('si','tal','pen','no')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ── RESULTADOS DE COMPETENCIA (lazo a lazo) ──
create table if not exists resultados_competencia (
  id uuid primary key default gen_random_uuid(),
  competencia_id text references competencias(id) on delete cascade,
  lazos jsonb not null default '[]',
  notas_generales text default '',
  fecha date not null default current_date,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(competencia_id)
);

-- ── ENTRENOS (sesiones de práctica, soporta múltiples por día) ──
create table if not exists entrenos (
  id uuid primary key default gen_random_uuid(),
  fecha date not null,
  sesion_num int default 1,
  tipo text default 'lazos',
  caballo text,
  duracion_min int,
  energia int check (energia between 1 and 5),
  foco text,
  notas text default '',
  lazos jsonb not null default '[]',
  efectivos int default 0,
  fallidos int default 0,
  total_marcados int default 0,
  efectividad_pct int default 0,
  created_at timestamptz default now()
);

-- ── FINANZAS ──
create table if not exists finanzas (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('premio','patrocinio','inscripcion','transporte','hotel','comida','caballo','otro_g')),
  monto bigint not null,
  competencia_id text references competencias(id) on delete set null,
  fecha date not null default current_date,
  nota text default '',
  created_at timestamptz default now()
);

-- ── CUADERNO ──
create table if not exists cuaderno_entradas (
  id uuid primary key default gen_random_uuid(),
  fecha date not null,
  texto text not null,
  created_at timestamptz default now()
);

-- ── CARTA DE LA CAMPEONA ──
create table if not exists carta_campeona (
  id int primary key default 1,
  fecha date,
  texto text,
  updated_at timestamptz default now(),
  constraint single_row check (id = 1)
);

-- ── REFLEXIONES POST-ENTRENAMIENTO ──
create table if not exists reflexiones (
  id uuid primary key default gen_random_uuid(),
  fecha date not null,
  presencia text,
  overthinking text,
  sensacion text,
  created_at timestamptz default now()
);

-- ── CABALLOS ──
create table if not exists caballos (
  nombre text primary key,
  created_at timestamptz default now()
);

-- ── FOCOS PERSONALIZADOS ──
create table if not exists focos_custom (
  nombre text primary key,
  created_at timestamptz default now()
);

-- ── CHECKLIST DIARIO ──
create table if not exists checklist_diario (
  fecha date primary key,
  items jsonb not null default '{}',
  updated_at timestamptz default now()
);

-- ── CONFIGURACIÓN GENERAL ──
create table if not exists config (
  clave text primary key,
  valor jsonb,
  updated_at timestamptz default now()
);

-- ════════════════════════════════════════
-- ÍNDICES
-- ════════════════════════════════════════
create index if not exists idx_entrenos_fecha on entrenos(fecha);
create index if not exists idx_finanzas_fecha on finanzas(fecha);
create index if not exists idx_finanzas_comp on finanzas(competencia_id);
create index if not exists idx_competencias_fecha on competencias(fecha_inicio);

-- ════════════════════════════════════════
-- RLS — abierto (app personal de Ana Isabel, sin login)
-- ════════════════════════════════════════
alter table competencias enable row level security;
alter table resultados_competencia enable row level security;
alter table entrenos enable row level security;
alter table finanzas enable row level security;
alter table cuaderno_entradas enable row level security;
alter table carta_campeona enable row level security;
alter table reflexiones enable row level security;
alter table caballos enable row level security;
alter table focos_custom enable row level security;
alter table checklist_diario enable row level security;
alter table config enable row level security;

create policy "allow_all_competencias" on competencias for all using (true) with check (true);
create policy "allow_all_resultados" on resultados_competencia for all using (true) with check (true);
create policy "allow_all_entrenos" on entrenos for all using (true) with check (true);
create policy "allow_all_finanzas" on finanzas for all using (true) with check (true);
create policy "allow_all_cuaderno" on cuaderno_entradas for all using (true) with check (true);
create policy "allow_all_carta" on carta_campeona for all using (true) with check (true);
create policy "allow_all_reflexiones" on reflexiones for all using (true) with check (true);
create policy "allow_all_caballos" on caballos for all using (true) with check (true);
create policy "allow_all_focos" on focos_custom for all using (true) with check (true);
create policy "allow_all_checklist" on checklist_diario for all using (true) with check (true);
create policy "allow_all_config" on config for all using (true) with check (true);

-- ════════════════════════════════════════
-- SEED: las 20 competencias del calendario 2026
-- ════════════════════════════════════════
insert into competencias (id, nombre, fecha_inicio, fecha_fin, lugar, tipo) values
('c01','🏆 Gran Lazo Millonario ASDESILLA','2026-06-05','2026-06-07','Rionegro, Antioquia','lazo'),
('c02','🥇 5º Campeonato de Lazo','2026-06-13','2026-06-14','Montería, Córdoba','campeonato'),
('c03','🪢 1er Nacional Lazo Técnico y Team Roping','2026-07-24','2026-07-24','Hda Las Margaritas, Cartago Valle','nacional'),
('c04','🏁 Finales Nacional Lazo Rápido','2026-07-25','2026-07-26','Hda Las Margaritas, Cartago Valle','nacional'),
('c05','🐎 4ª Vaquería Equestria by Classic Equine','2026-07-25','2026-07-25','Villavicencio, Meta','vaqueria'),
('c06','🌬️ 4ª Versión Vientos de Agosto','2026-08-08','2026-08-09','Cumaral, Meta','vaqueria'),
('c07','🐄 Vaquería Hacienda Los Chapitos','2026-08-08','2026-08-09','Planeta Rica, Córdoba','vaqueria'),
('c08','🏅 1er Nacional Vaquería Rancho San Antonio','2026-08-15','2026-08-16','Rionegro, Antioquia','nacional'),
('c09','🌄 3er Regional de Vaquería','2026-08-16','2026-08-16','Castilla La Nueva, Meta','regional'),
('c10','☕ Válida Circuito Eje Cafetero Vaqueros Quindío','2026-08-22','2026-08-22','La Tebaida, Quindío','circuito'),
('c11','🏔️ 4ª Válida Circuito Antioqueño','2026-08-29','2026-08-29','Las Yeguas','circuito'),
('c12','🦁 Batalla de Llano — Parque Malokas','2026-09-11','2026-09-13','Villavicencio, Meta','vaqueria'),
('c13','🪢 Evento de Lazo','2026-09-26','2026-09-27','Planeta Rica, Córdoba','lazo'),
('c14','☕ Válida Circuito Eje Cafetero Hda Guadalupe','2026-10-03','2026-10-03','Tres Puertas, Manizales','circuito'),
('c15','🥇 3er Campeonato Lazo Arena Los Potrillos','2026-10-03','2026-10-04','Montería, Córdoba','campeonato'),
('c16','🤠 Vaquería Rancho Vaquero','2026-10-10','2026-10-11','Mutata, Antioquia','vaqueria'),
('c17','🔴 Galardón Rojo — Criadero Juanambu','2026-10-24','2026-10-25','Villavicencio, Meta','vaqueria'),
('c18','🏅 Nacional Vaquería Hda Guadalupe','2026-11-14','2026-11-15','Tres Puertas, Manizales','nacional'),
('c19','🏔️ 6ª Válida Circuito Antioqueño','2026-11-21','2026-11-21','Rancho San Antonio','circuito'),
('c20','☕ Válida Circuito Eje Cafetero Hda Las Margaritas','2026-12-05','2026-12-05','Cartago, Valle','circuito')
on conflict (id) do nothing;
