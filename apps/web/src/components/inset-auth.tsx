import { useQueryClient } from "@tanstack/react-query";
import { Link, useNavigate } from "@tanstack/react-router";
import {
  ChevronLeftIcon,
  CheckIcon,
  EyeIcon,
  EyeOffIcon,
  Loader2Icon,
  MailIcon,
  ShuffleIcon,
  XIcon,
} from "lucide-react";
import { type FormEvent, useEffect, useMemo, useRef, useState } from "react";

import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Field, FieldDescription, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { InputGroup, InputGroupAddon, InputGroupInput } from "@/components/ui/input-group";
import { Separator } from "@/components/ui/separator";
import { normalizeAuthError } from "@/lib/auth/auth-error-messages";
import { authClient, getSession, signIn, signUp } from "@/lib/auth/client";
import { cn } from "@/lib/utils";

/* ------------------------------------------------------------------ */
/*  Layout común                                                       */
/* ------------------------------------------------------------------ */

export function InsetSigninPage() {
  const [email, setEmail] = useState("");

  return (
    <>
      <Heading title="Bienvenido de nuevo" subtitle="Inicia sesión para continuar." />
      <OAuthRow />
      <MagicLinkButton email={email} />
      <OrSeparator />
      <SignInForm email={email} setEmail={setEmail} />
      <div className="mt-5 flex flex-col gap-2 text-sm sm:flex-row sm:items-baseline sm:justify-between sm:gap-4">
        <p className="text-muted-foreground">
          ¿No tienes cuenta?{" "}
          <Link to="/auth/signup" className="text-foreground hover:underline">
            Regístrate
          </Link>
        </p>
        <Link
          to="/auth/reset-password"
          className="text-muted-foreground hover:text-foreground hover:underline"
        >
          ¿Olvidaste tu contraseña?
        </Link>
      </div>
      <p className="text-muted-foreground mt-4 px-4 text-center text-[11px] leading-relaxed">
        Al continuar, aceptas nuestras{" "}
        <Link to="/policies" className="text-foreground hover:underline">
          políticas y condiciones de uso
        </Link>
        .
      </p>
    </>
  );
}

export function InsetSignupPage() {
  return (
    <>
      <Heading title="Crea tu cuenta" subtitle="Completa el formulario para registrarte." />
      <OAuthRow />
      <MagicLinkButton />
      <OrSeparator />
      <SignUpForm />
      <div className="text-muted-foreground mt-5 text-center text-sm">
        ¿Ya tienes una cuenta?{" "}
        <Link to="/auth/signin" className="text-foreground hover:underline">
          Inicia sesión
        </Link>
      </div>
      <p className="text-muted-foreground mt-4 px-4 text-center text-[11px] leading-relaxed">
        Al continuar, aceptas nuestras{" "}
        <Link to="/policies" className="text-foreground hover:underline">
          políticas y condiciones de uso
        </Link>
        .
      </p>
    </>
  );
}

/* ------------------------------------------------------------------ */
/*  Backdrop + Left panel                                              */
/* ------------------------------------------------------------------ */

function PageBackdrop() {
  return (
    <div
      aria-hidden
      className="pointer-events-none absolute inset-0"
      style={{
        background: [
          "radial-gradient(60% 50% at 10% 10%, color-mix(in srgb, var(--primary) 10%, transparent), transparent 65%)",
          "radial-gradient(50% 50% at 90% 100%, color-mix(in srgb, var(--foreground) 6%, transparent), transparent 65%)",
        ].join(", "),
      }}
    />
  );
}

export function AuthPageBackdrop() {
  return <PageBackdrop />;
}

type Palette = {
  name: string;
  colors: [
    [number, number, number],
    [number, number, number],
    [number, number, number],
    [number, number, number],
  ];
};

const PALETTES: Palette[] = [
  {
    name: "Slate",
    colors: [
      [0.04, 0.04, 0.07],
      [0.13, 0.13, 0.17],
      [0.22, 0.22, 0.3],
      [0.06, 0.06, 0.1],
    ],
  },
  {
    name: "Aurora",
    colors: [
      [0.05, 0.08, 0.16],
      [0.1, 0.32, 0.48],
      [0.42, 0.2, 0.58],
      [0.06, 0.1, 0.18],
    ],
  },
  {
    name: "Sunset",
    colors: [
      [0.1, 0.05, 0.1],
      [0.62, 0.22, 0.28],
      [0.5, 0.38, 0.2],
      [0.18, 0.05, 0.12],
    ],
  },
  {
    name: "Forest",
    colors: [
      [0.04, 0.09, 0.07],
      [0.08, 0.32, 0.26],
      [0.1, 0.2, 0.32],
      [0.05, 0.11, 0.1],
    ],
  },
  {
    name: "Plum",
    colors: [
      [0.1, 0.05, 0.14],
      [0.5, 0.16, 0.5],
      [0.26, 0.1, 0.42],
      [0.08, 0.04, 0.12],
    ],
  },
  {
    name: "Cyber",
    colors: [
      [0.04, 0.06, 0.12],
      [0.06, 0.42, 0.52],
      [0.55, 0.1, 0.38],
      [0.05, 0.05, 0.12],
    ],
  },
  {
    name: "Ember",
    colors: [
      [0.1, 0.04, 0.04],
      [0.62, 0.26, 0.1],
      [0.45, 0.1, 0.1],
      [0.1, 0.05, 0.05],
    ],
  },
  {
    name: "Ice",
    colors: [
      [0.05, 0.07, 0.12],
      [0.2, 0.32, 0.55],
      [0.32, 0.42, 0.58],
      [0.07, 0.09, 0.16],
    ],
  },
];

function LeftPanel() {
  const [paletteIndex, setPaletteIndex] = useState(1);
  const palette = PALETTES[paletteIndex];

  const shuffle = () => {
    setPaletteIndex((current) => {
      let next = current;
      while (next === current) {
        next = Math.floor(Math.random() * PALETTES.length);
      }
      return next;
    });
  };

  return (
    <div className="relative hidden overflow-hidden bg-[#0a0a0c] lg:block">
      <MeshShader palette={palette} />
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0"
        style={{
          background:
            "radial-gradient(120% 80% at 50% 50%, transparent 35%, rgba(0,0,0,0.55) 100%)",
        }}
      />

      <div className="relative flex h-full flex-col justify-between p-12">
        <div className="flex items-start justify-between">
          <button
            type="button"
            onClick={() => window.history.back()}
            className="inline-flex w-fit cursor-pointer items-center gap-1.5 rounded-md bg-black/20 px-2 py-1 font-mono text-[11px] tracking-[0.2em] text-white/65 uppercase backdrop-blur-sm transition-colors hover:text-white"
          >
            <ChevronLeftIcon className="size-3.5" />
            Volver
          </button>
          <ShuffleButton onClick={shuffle} paletteName={palette.name} />
        </div>

        <div className="max-w-md">
          <h2
            className="font-heading text-3xl leading-tight font-semibold md:text-4xl"
            style={{ textShadow: "0 1px 24px rgba(0,0,0,0.55)" }}
          >
            <span className="text-white">Claustrum.</span>
            <br />
            <span className="text-white/55">Tu espacio académico</span>{" "}
            <span className="text-white">para organizar</span>{" "}
            <span className="text-white/55">tu avance.</span>
          </h2>
          <p
            className="mt-5 max-w-sm text-sm leading-relaxed text-white/65"
            style={{ textShadow: "0 1px 16px rgba(0,0,0,0.55)" }}
          >
            Planes de estudio, horarios y evaluaciones en un solo lugar para enfocarte en lo que
            importa.
          </p>
        </div>
      </div>
    </div>
  );
}

export function AuthLeftPanel() {
  return <LeftPanel />;
}

function ShuffleButton({ onClick, paletteName }: { onClick: () => void; paletteName: string }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="group inline-flex items-center gap-2 rounded-md border border-white/10 bg-black/30 px-2.5 py-1.5 text-white/75 backdrop-blur-sm transition-colors hover:border-white/20 hover:bg-black/40 hover:text-white focus-visible:ring-2 focus-visible:ring-white/30 focus-visible:outline-none"
    >
      <ShuffleIcon className="size-3.5 transition-transform group-hover:rotate-12" />
      <span className="font-mono text-[10px] tracking-[0.2em] uppercase">{paletteName}</span>
    </button>
  );
}

const VERT_SRC = `
attribute vec2 a_position;
void main() {
  gl_Position = vec4(a_position, 0.0, 1.0);
}`;

const FRAG_SRC = `
precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec3 u_c0;
uniform vec3 u_c1;
uniform vec3 u_c2;
uniform vec3 u_c3;

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv.y = 1.0 - uv.y;
  float t = u_time * 0.00015;

  vec2 p0 = vec2(0.30 + sin(t * 0.70) * 0.25, 0.25 + cos(t * 0.60) * 0.20);
  vec2 p1 = vec2(0.75 + cos(t * 0.50) * 0.20, 0.70 + sin(t * 0.80) * 0.20);
  vec2 p2 = vec2(0.50 + sin(t * 0.40 + 1.0) * 0.30, 0.50 + cos(t * 0.70) * 0.25);
  vec2 p3 = vec2(0.20 + cos(t * 0.55) * 0.20, 0.85 + sin(t * 0.45) * 0.15);

  float r = 0.55;
  float d0 = pow(1.0 - smoothstep(0.0, r, distance(uv, p0)), 1.4);
  float d1 = pow(1.0 - smoothstep(0.0, r, distance(uv, p1)), 1.4);
  float d2 = pow(1.0 - smoothstep(0.0, r, distance(uv, p2)), 1.4);
  float d3 = pow(1.0 - smoothstep(0.0, r, distance(uv, p3)), 1.4);

  float total = d0 + d1 + d2 + d3 + 0.0001;
  vec3 col = (u_c0 * d0 + u_c1 * d1 + u_c2 * d2 + u_c3 * d3) / total;

  // grain
  float n = fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
  col += (n - 0.5) * 0.025;

  gl_FragColor = vec4(col, 1.0);
}`;

function MeshShader({ palette }: { palette: Palette }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const targetRef = useRef(palette.colors);
  const currentRef = useRef(palette.colors.map((c) => [...c]) as Palette["colors"]);

  useEffect(() => {
    targetRef.current = palette.colors;
  }, [palette]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const gl = canvas.getContext("webgl", { antialias: false, alpha: false });
    if (!gl) return;

    const compile = (type: number, src: string) => {
      const sh = gl.createShader(type);
      if (!sh) return null;
      gl.shaderSource(sh, src);
      gl.compileShader(sh);
      if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
        gl.deleteShader(sh);
        return null;
      }
      return sh;
    };

    const vs = compile(gl.VERTEX_SHADER, VERT_SRC);
    const fs = compile(gl.FRAGMENT_SHADER, FRAG_SRC);
    if (!vs || !fs) return;

    const prog = gl.createProgram();
    if (!prog) return;
    gl.attachShader(prog, vs);
    gl.attachShader(prog, fs);
    gl.linkProgram(prog);
    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) return;
    gl.useProgram(prog);

    const buf = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buf);
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array([-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1]),
      gl.STATIC_DRAW,
    );
    const posLoc = gl.getAttribLocation(prog, "a_position");
    gl.enableVertexAttribArray(posLoc);
    gl.vertexAttribPointer(posLoc, 2, gl.FLOAT, false, 0, 0);

    const uRes = gl.getUniformLocation(prog, "u_resolution");
    const uTime = gl.getUniformLocation(prog, "u_time");
    const uC0 = gl.getUniformLocation(prog, "u_c0");
    const uC1 = gl.getUniformLocation(prog, "u_c1");
    const uC2 = gl.getUniformLocation(prog, "u_c2");
    const uC3 = gl.getUniformLocation(prog, "u_c3");

    const resize = () => {
      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      const w = Math.max(1, Math.floor(canvas.clientWidth * dpr));
      const h = Math.max(1, Math.floor(canvas.clientHeight * dpr));
      if (canvas.width !== w || canvas.height !== h) {
        canvas.width = w;
        canvas.height = h;
        gl.viewport(0, 0, w, h);
      }
    };

    const ro = new ResizeObserver(resize);
    ro.observe(canvas);
    resize();

    let raf = 0;
    const start = performance.now();
    const tick = (now: number) => {
      const t = now - start;
      const k = 0.06;
      for (let i = 0; i < 4; i++) {
        for (let j = 0; j < 3; j++) {
          currentRef.current[i][j] += (targetRef.current[i][j] - currentRef.current[i][j]) * k;
        }
      }
      gl.uniform2f(uRes, canvas.width, canvas.height);
      gl.uniform1f(uTime, t);
      const c = currentRef.current;
      gl.uniform3f(uC0, c[0][0], c[0][1], c[0][2]);
      gl.uniform3f(uC1, c[1][0], c[1][1], c[1][2]);
      gl.uniform3f(uC2, c[2][0], c[2][1], c[2][2]);
      gl.uniform3f(uC3, c[3][0], c[3][1], c[3][2]);
      gl.drawArrays(gl.TRIANGLES, 0, 6);
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);

    return () => {
      cancelAnimationFrame(raf);
      ro.disconnect();
      gl.deleteProgram(prog);
      gl.deleteShader(vs);
      gl.deleteShader(fs);
      gl.deleteBuffer(buf);
    };
  }, []);

  return <canvas ref={canvasRef} aria-hidden className="absolute inset-0 block h-full w-full" />;
}

/* ------------------------------------------------------------------ */
/*  Componentes comunes de UI                                          */
/* ------------------------------------------------------------------ */

function Heading({ title, subtitle }: { title: string; subtitle: string }) {
  return (
    <div className="mt-6 flex flex-col gap-1.5">
      <h1 className="font-heading text-2xl font-semibold tracking-tight">{title}</h1>
      <p className="text-muted-foreground text-sm">{subtitle}</p>
    </div>
  );
}

function OAuthRow() {
  return (
    <div className="mt-4 grid grid-cols-1 gap-2.5">
      <GoogleOAuthButton />
    </div>
  );
}

function GoogleOAuthButton() {
  const [pending, setPending] = useState(false);
  const lastMethod = authClient.getLastUsedLoginMethod();

  const onGoogleSignIn = async () => {
    setPending(true);
    const { error } = await signIn.social({
      provider: "google",
      callbackURL: `${window.location.origin}/`,
    });

    if (error) {
      alert(normalizeAuthError(error, "login").message);
      setPending(false);
    }
  };

  return (
    <Button
      variant="outline"
      size="lg"
      className="relative w-full"
      onClick={onGoogleSignIn}
      disabled={pending}
    >
      <span className="size-4 shrink-0 [&_svg]:size-4">
        <GoogleIcon />
      </span>
      <span className="truncate whitespace-nowrap">Google</span>
      {lastMethod === "google" && (
        <Badge
          variant="secondary"
          className="pointer-events-none absolute -top-2.5 -right-2 h-5 px-1.5 py-0 text-[10px] font-bold shadow-sm"
        >
          Último usado
        </Badge>
      )}
    </Button>
  );
}

const MAGIC_LINK_EMAIL_KEY = "claustrum.auth.magic_link_email";
const VERIFY_EMAIL_KEY = "claustrum.auth.verify_email";

import { resetSupabaseAuthTokenState } from "@/lib/supabase/browser-client";

async function invalidateAuthFlowQueries(
  queryClient: ReturnType<typeof useQueryClient>,
  userId?: string,
) {
  resetSupabaseAuthTokenState();

  await queryClient.invalidateQueries({ queryKey: ["appState"] });
  queryClient.removeQueries({ queryKey: ["authUser"] }); // fallback for any old queries

  if (userId) {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ["profile", userId] }),
      queryClient.invalidateQueries({ queryKey: ["onboardingStatus", userId] }),
      queryClient.invalidateQueries({ queryKey: ["userStudyPlan", userId] }),
      queryClient.invalidateQueries({ queryKey: ["dashboardStats", userId] }),
    ]);
  }
}

async function getPostSignInRedirect() {
  return "/" as const;
}

function MagicLinkButton({ email = "" }: { email?: string }) {
  const navigate = useNavigate();
  const [pending, setPending] = useState(false);
  const lastMethod = authClient.getLastUsedLoginMethod();

  const onSendMagicLink = async () => {
    const trimmedEmail = email.trim();
    if (!trimmedEmail) {
      void navigate({ to: "/auth/magic-link" });
      return;
    }

    if (!/^\S+@\S+\.\S+$/.test(trimmedEmail)) {
      return;
    }

    setPending(true);
    const { error } = await signIn.magicLink({
      email: trimmedEmail,
      callbackURL: `${window.location.origin}/auth/signin`,
    });

    if (error) {
      alert(normalizeAuthError(error, "login").message);
      setPending(false);
      return;
    }

    window.sessionStorage.setItem(MAGIC_LINK_EMAIL_KEY, trimmedEmail);
    void navigate({ to: "/auth/magic-link" });
    setPending(false);
  };

  return (
    <Button
      variant="outline"
      size="lg"
      className="relative mt-2 w-full"
      type="button"
      disabled={pending}
      onClick={onSendMagicLink}
    >
      <MailIcon />
      {pending ? "Enviando enlace..." : "Continuar con enlace mágico"}
      {lastMethod === "magic-link" && (
        <Badge
          variant="secondary"
          className="pointer-events-none absolute -top-2.5 -right-2 h-5 px-1.5 py-0 text-[10px] font-bold shadow-sm"
        >
          Último usado
        </Badge>
      )}
    </Button>
  );
}

function OrSeparator() {
  return (
    <div className="my-4 flex items-center gap-3">
      <Separator className="flex-1" />
      <span className="text-muted-foreground text-[11px]">O</span>
      <Separator className="flex-1" />
    </div>
  );
}

function GoogleIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden>
      <path
        fill="#EA4335"
        d="M12 5c1.7 0 3.2.6 4.4 1.7l3.3-3.3C17.7 1.5 15 .5 12 .5 7.3.5 3.3 3.2 1.4 7.1l3.8 3c.9-2.8 3.5-4.6 6.8-4.6Z"
      />
      <path
        fill="#34A853"
        d="M23.5 12.3c0-.8-.1-1.6-.2-2.3H12v4.4h6.5c-.3 1.5-1.1 2.7-2.4 3.6l3.7 2.9c2.2-2 3.7-5 3.7-8.6Z"
      />
      <path
        fill="#FBBC05"
        d="M5.2 14.1c-.2-.7-.4-1.4-.4-2.1s.1-1.4.4-2.1l-3.8-3C.5 8.7 0 10.3 0 12s.5 3.3 1.4 4.7l3.8-2.6Z"
      />
      <path
        fill="#4285F4"
        d="M12 23.5c3.2 0 5.9-1.1 7.9-2.9l-3.7-2.9c-1 .7-2.4 1.2-4.2 1.2-3.3 0-6-2-6.9-4.6l-3.8 3C3.3 20.8 7.3 23.5 12 23.5Z"
      />
    </svg>
  );
}

/* ------------------------------------------------------------------ */
/*  Formulario de Sign In                                              */
/* ------------------------------------------------------------------ */

function SignInForm({ email, setEmail }: { email: string; setEmail: (value: string) => void }) {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [password, setPassword] = useState("");
  const [reveal, setReveal] = useState(false);
  const [pending, setPending] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);

  useEffect(() => {
    const bootstrapSession = async () => {
      const { data: session } = await getSession();
      if (session) {
        await queryClient.invalidateQueries({ queryKey: ["appState"] });
        void navigate({ to: await getPostSignInRedirect(), replace: true });
      }
    };

    void bootstrapSession();

    return undefined;
  }, [navigate, queryClient]);

  const onSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setFormError(null);
    if (!email.trim() || !password) return;
    setPending(true);

    const { data, error } = await signIn.email({
      email: email.trim(),
      password,
    });

    if (error) {
      const normalizedError = normalizeAuthError(error, "login");
      if (normalizedError.type === "email_unconfirmed") {
        window.sessionStorage.setItem(VERIFY_EMAIL_KEY, email.trim());
        void navigate({ to: "/auth/verify-email", replace: true });
        return;
      }
      setFormError(normalizedError.message);
      setPending(false);
      return;
    }

    if (data && "twoFactorRedirect" in data && data.twoFactorRedirect) {
      void navigate({ to: "/auth/2fa", replace: true });
      return;
    }

    const { data: session } = await getSession();
    await invalidateAuthFlowQueries(queryClient, session?.user.id);
    void navigate({ to: await getPostSignInRedirect(), replace: true });
    setPending(false);
  };

  return (
    <form onSubmit={onSubmit} className="flex flex-col gap-4">
      {formError ? (
        <Alert variant="destructive">
          <AlertDescription>{formError}</AlertDescription>
        </Alert>
      ) : null}
      <Field>
        <div className="flex items-center justify-between">
          <FieldLabel htmlFor="login-email">
            Correo electrónico <span className="text-muted-foreground">*</span>
          </FieldLabel>
          {authClient.getLastUsedLoginMethod() === "email" && (
            <Badge
              variant="secondary"
              className="pointer-events-none h-5 px-1.5 py-0 text-[10px] font-bold"
            >
              Último usado
            </Badge>
          )}
        </div>
        <Input
          id="login-email"
          type="email"
          required
          placeholder="nombre@ejemplo.com"
          autoComplete="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </Field>

      <Field>
        <FieldLabel htmlFor="login-password">
          Contraseña <span className="text-muted-foreground">*</span>
        </FieldLabel>
        <InputGroup>
          <InputGroupInput
            id="login-password"
            type={reveal ? "text" : "password"}
            required
            placeholder="••••••••"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <InputGroupAddon align="inline-end">
            <button
              type="button"
              onClick={() => setReveal((v) => !v)}
              aria-label={reveal ? "Ocultar contraseña" : "Mostrar contraseña"}
              className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none"
            >
              {reveal ? <EyeOffIcon className="size-4" /> : <EyeIcon className="size-4" />}
            </button>
          </InputGroupAddon>
        </InputGroup>
      </Field>

      <Button type="submit" size="lg" className="mt-2" disabled={pending}>
        {pending ? <Loader2Icon className="animate-spin" /> : null}
        {pending ? "Iniciando sesión..." : "Iniciar sesión"}
      </Button>
    </form>
  );
}

/* ------------------------------------------------------------------ */
/*  Formulario de Sign Up                                              */
/* ------------------------------------------------------------------ */

const passwordRequirements = [
  { regex: /.{8,}/, text: "Al menos 8 caracteres" },
  { regex: /[a-z]/, text: "Al menos 1 letra minúscula" },
  { regex: /[A-Z]/, text: "Al menos 1 letra mayúscula" },
  { regex: /[0-9]/, text: "Al menos 1 número" },
  {
    regex: /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/,
    text: "Al menos 1 carácter especial",
  },
];

function getStrengthColor(score: number) {
  if (score === 0) return "bg-border";
  if (score <= 1) return "bg-destructive";
  if (score <= 2) return "bg-orange-500";
  if (score <= 3) return "bg-amber-500";
  if (score === 4) return "bg-yellow-400";
  return "bg-green-500";
}

function getStrengthText(score: number) {
  if (score === 0) return "Ingresa una contraseña";
  if (score <= 2) return "Contraseña débil";
  if (score <= 3) return "Contraseña media";
  if (score === 4) return "Contraseña fuerte";
  return "Contraseña muy fuerte";
}

function SignUpForm() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);
  const [isConfirmPasswordVisible, setIsConfirmPasswordVisible] = useState(false);
  const [pending, setPending] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);
  const [nameError, setNameError] = useState<string | null>(null);
  const [emailError, setEmailError] = useState<string | null>(null);
  const [passwordError, setPasswordError] = useState<string | null>(null);
  const [confirmPasswordError, setConfirmPasswordError] = useState<string | null>(null);

  const passwordStrength = useMemo(
    () =>
      passwordRequirements.map((requirement) => ({
        met: requirement.regex.test(password),
        text: requirement.text,
      })),
    [password],
  );

  const passwordStrengthScore = useMemo(
    () => passwordStrength.filter((requirement) => requirement.met).length,
    [passwordStrength],
  );

  useEffect(() => {
    const bootstrapSession = async () => {
      const { data: session } = await getSession();
      if (session) {
        await queryClient.invalidateQueries({ queryKey: ["appState"] });
        void navigate({ to: "/overview", replace: true });
      }
    };

    void bootstrapSession();

    return undefined;
  }, [navigate, queryClient]);

  const validateFields = () => {
    let hasError = false;

    if (!name.trim()) {
      setNameError("Ingresa tu nombre completo.");
      hasError = true;
    } else {
      setNameError(null);
    }

    const trimmedEmail = email.trim();
    if (!trimmedEmail) {
      setEmailError("Ingresa tu correo electrónico.");
      hasError = true;
    } else if (!/^\S+@\S+\.\S+$/.test(trimmedEmail)) {
      setEmailError("Ingresa un correo electrónico válido.");
      hasError = true;
    } else {
      setEmailError(null);
    }

    if (!password) {
      setPasswordError("Ingresa una contraseña.");
      hasError = true;
    } else if (password.length < 8) {
      setPasswordError("La contraseña debe tener al menos 8 caracteres.");
      hasError = true;
    } else {
      setPasswordError(null);
    }

    if (!confirmPassword) {
      setConfirmPasswordError("Confirma tu contraseña.");
      hasError = true;
    } else if (password !== confirmPassword) {
      setConfirmPasswordError("Las contraseñas no coinciden.");
      hasError = true;
    } else {
      setConfirmPasswordError(null);
    }

    return !hasError;
  };

  const onSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setFormError(null);

    if (!validateFields()) return;
    setPending(true);

    const { data, error } = await signUp.email({
      email,
      password,
      name,
      callbackURL: `${window.location.origin}/auth/verify-email`,
    });

    if (error) {
      setFormError(normalizeAuthError(error, "signup").message);
      setPending(false);
      return;
    }

    if (data?.user.id) await invalidateAuthFlowQueries(queryClient, data.user.id);
    window.sessionStorage.setItem(VERIFY_EMAIL_KEY, email.trim());
    void navigate({ to: "/auth/verify-email", replace: true });
    setPending(false);
  };

  return (
    <form onSubmit={onSubmit} className="flex flex-col gap-4">
      {formError ? (
        <Alert variant="destructive">
          <AlertDescription>{formError}</AlertDescription>
        </Alert>
      ) : null}

      <Field>
        <FieldLabel htmlFor="signup-name">
          Nombre completo <span className="text-muted-foreground">*</span>
        </FieldLabel>
        <Input
          id="signup-name"
          type="text"
          required
          placeholder="Juan Pérez"
          value={name}
          aria-invalid={Boolean(nameError)}
          onChange={(e) => {
            setName(e.target.value);
            setNameError(null);
            setFormError(null);
          }}
        />
        <FieldError>{nameError}</FieldError>
      </Field>

      <Field>
        <FieldLabel htmlFor="signup-email">
          Correo electrónico <span className="text-muted-foreground">*</span>
        </FieldLabel>
        <Input
          id="signup-email"
          type="email"
          required
          placeholder="nombre@ejemplo.com"
          value={email}
          aria-invalid={Boolean(emailError)}
          onChange={(e) => {
            setEmail(e.target.value);
            setEmailError(null);
            setFormError(null);
          }}
        />
        <FieldError>{emailError}</FieldError>
      </Field>

      <Field>
        <FieldLabel htmlFor="signup-password">
          Contraseña <span className="text-muted-foreground">*</span>
        </FieldLabel>
        <InputGroup>
          <InputGroupInput
            id="signup-password"
            type={isPasswordVisible ? "text" : "password"}
            required
            placeholder="••••••••"
            value={password}
            aria-invalid={Boolean(passwordError)}
            onChange={(e) => {
              setPassword(e.target.value);
              setPasswordError(null);
              setConfirmPasswordError(null);
              setFormError(null);
            }}
          />
          <InputGroupAddon align="inline-end">
            <button
              type="button"
              onClick={() => setIsPasswordVisible((v) => !v)}
              aria-label={isPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña"}
              className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none"
            >
              {isPasswordVisible ? (
                <EyeOffIcon className="size-4" />
              ) : (
                <EyeIcon className="size-4" />
              )}
            </button>
          </InputGroupAddon>
        </InputGroup>
        <FieldError>{passwordError}</FieldError>

        <div className="mt-1 space-y-1">
          <div className="flex h-1 w-full gap-1">
            {Array.from({ length: 5 }).map((_, index) => (
              <span
                key={index}
                className={cn(
                  "h-full flex-1 rounded-full transition-all duration-300 ease-out",
                  index < passwordStrengthScore
                    ? getStrengthColor(passwordStrengthScore)
                    : "bg-border",
                )}
              />
            ))}
          </div>
          <p className="text-sm font-medium">{getStrengthText(passwordStrengthScore)}.</p>
          <ul className="space-y-1">
            {passwordStrength.map((requirement) => (
              <li key={requirement.text} className="flex items-center gap-2">
                {requirement.met ? (
                  <CheckIcon className="size-4 text-green-600 dark:text-green-400" />
                ) : (
                  <XIcon className="text-muted-foreground size-4" />
                )}
                <span
                  className={cn(
                    "text-xs",
                    requirement.met
                      ? "text-green-600 dark:text-green-400"
                      : "text-muted-foreground",
                  )}
                >
                  {requirement.text}
                  <span className="sr-only">
                    {requirement.met ? " - Requisito cumplido" : " - Requisito pendiente"}
                  </span>
                </span>
              </li>
            ))}
          </ul>
        </div>
      </Field>

      <Field>
        <FieldLabel htmlFor="signup-confirm-password">
          Confirmar contraseña <span className="text-muted-foreground">*</span>
        </FieldLabel>
        <InputGroup>
          <InputGroupInput
            id="signup-confirm-password"
            type={isConfirmPasswordVisible ? "text" : "password"}
            required
            placeholder="••••••••"
            value={confirmPassword}
            aria-invalid={Boolean(confirmPasswordError)}
            onChange={(e) => {
              setConfirmPassword(e.target.value);
              setConfirmPasswordError(null);
              setFormError(null);
            }}
          />
          <InputGroupAddon align="inline-end">
            <button
              type="button"
              onClick={() => setIsConfirmPasswordVisible((v) => !v)}
              aria-label={
                isConfirmPasswordVisible ? "Ocultar confirmación" : "Mostrar confirmación"
              }
              className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/40 cursor-pointer rounded p-1 transition-colors focus-visible:ring-2 focus-visible:outline-none"
            >
              {isConfirmPasswordVisible ? (
                <EyeOffIcon className="size-4" />
              ) : (
                <EyeIcon className="size-4" />
              )}
            </button>
          </InputGroupAddon>
        </InputGroup>
        <FieldError>{confirmPasswordError}</FieldError>
        <FieldDescription>Por favor confirma tu contraseña.</FieldDescription>
      </Field>

      <Button type="submit" size="lg" className="mt-2" disabled={pending}>
        {pending ? <Loader2Icon className="animate-spin" /> : null}
        {pending ? "Creando cuenta..." : "Crear cuenta"}
      </Button>
    </form>
  );
}
