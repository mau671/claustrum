import { useLocation } from "@tanstack/react-router";
import { Check, Copy, Mail } from "lucide-react";
import { useEffect, useState } from "react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";

const EmailContact = () => {
  const [copied, setCopied] = useState(false);
  const email = "claustrum@maugp.com";

  const handleCopy = () => {
    void navigator.clipboard.writeText(email);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <Popover>
      <PopoverTrigger asChild>
        <button
          type="button"
          className="text-primary decoration-primary/50 hover:text-primary/80 font-medium underline decoration-dashed underline-offset-4 focus:outline-none"
        >
          {email}
        </button>
      </PopoverTrigger>
      <PopoverContent
        className="w-[90vw] space-y-4 p-4 sm:w-[420px]"
        align="start"
        onOpenAutoFocus={(e) => e.preventDefault()}
      >
        <Input readOnly value={email} className="bg-muted/50 cursor-text" />
        <div className="flex flex-col gap-2 sm:flex-row">
          <Button
            variant="outline"
            size="sm"
            className="w-full justify-center gap-2 sm:flex-1"
            onClick={handleCopy}
          >
            {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
            {copied ? "Copiado" : "Copiar correo"}
          </Button>
          <Button
            variant="outline"
            size="sm"
            className="w-full justify-center gap-2 sm:flex-1"
            asChild
          >
            <a href={`mailto:${email}`}>
              <Mail className="h-4 w-4" />
              Abrir aplicación de correo
            </a>
          </Button>
        </div>
      </PopoverContent>
    </Popover>
  );
};

const ITCR = () => (
  <>
    <span className="md:hidden">ITCR</span>
    <span className="hidden md:inline">
      <Tooltip delayDuration={300}>
        <TooltipTrigger
          type="button"
          className="decoration-primary/50 cursor-help underline decoration-dashed underline-offset-4"
        >
          ITCR
        </TooltipTrigger>
        <TooltipContent>
          <p>Instituto Tecnológico de Costa Rica</p>
        </TooltipContent>
      </Tooltip>
    </span>
  </>
);

type PolicySection = {
  id: string;
  title: string;
  paragraphs: (string | React.ReactNode)[];
  bullets?: string[];
};

const sections: PolicySection[] = [
  {
    id: "objeto-y-alcance",
    title: "Objeto y alcance",
    paragraphs: [
      "Este reglamento establece las condiciones de uso del servicio y fija un marco de convivencia para las interacciones que se desarrollen dentro de este espacio, con la finalidad de ofrecer una herramienta útil para el estudio y reducir riesgos relacionados con publicaciones ofensivas, divulgación indebida de información, uso no autorizado de materiales y conductas que afecten la integridad académica.",
      <>
        Estas reglas se aplican a toda persona que consulte horarios, revise información de cursos y
        docentes, publique reseñas o comparta materiales históricos de estudio, sirviendo como un
        documento que define criterios de uso responsable sin reemplazar reglamentos institucionales
        ni sustituir los canales formales del <ITCR /> para trámites, reclamos o denuncias
        oficiales.
      </>,
    ],
  },
  {
    id: "naturaleza-independiente-y-no-oficial",
    title: "Naturaleza independiente y no oficial de la plataforma",
    paragraphs: [
      "Este servicio es un proyecto estudiantil independiente y no oficial que no pertenece al Instituto Tecnológico de Costa Rica, por lo que no está patrocinado por la institución ni actúa como vocería de ninguna escuela, carrera, cátedra o unidad administrativa.",
      <>
        Los horarios, reseñas, materiales y demás contenidos se ofrecen como apoyo académico
        comunitario, de modo que cualquier referencia al <ITCR /> debe entenderse estrictamente en
        un contexto informativo y no como señal de afiliación, patrocinio o aval institucional,
        dejando claro que esta plataforma tampoco sustituye comunicados, repositorios ni sistemas
        oficiales del Instituto.
      </>,
    ],
  },
  {
    id: "definiciones-basicas",
    title: "Definiciones básicas",
    paragraphs: [
      "Para efectos de esta política, se entiende por usuario a cualquier persona que acceda o utilice el servicio, con o sin cuenta registrada, mientras que se entiende por contenido a toda reseña, comentario, archivo, texto, documento o publicación incorporada a este espacio.",
      "El material académico incluye, entre otros, exámenes, prácticas, proyectos, guías, documentos y recursos de estudio, considerándose como contenido prohibido toda publicación que incumpla estas reglas, afecte derechos de terceros o genere un riesgo razonable para la dignidad personal, la privacidad, la propiedad intelectual o la integridad académica.",
    ],
  },
  {
    id: "reglas-generales-de-uso",
    title: "Reglas generales de uso",
    paragraphs: [
      "Dado que este espacio está pensado para fines académicos e informativos, toda interacción debe mantenerse dentro de un marco de respeto hacia docentes, estudiantes y cualquier otra persona mencionada en publicaciones, asegurando que el contenido enviado evite afirmaciones falsas, ofensivas o divulgaciones indebidas.",
      "Se prohíbe publicar contenido insultante, humillante, discriminatorio, difamatorio, calumnioso o acosador, así como cualquier mensaje que vulnere la dignidad, la intimidad o la reputación de terceros, prohibiéndose de igual forma la suplantación de identidad, la intimidación, el hostigamiento y la divulgación de datos personales innecesarios o sensibles.",
      "Asimismo, podrán restringirse conductas que comprometan la seguridad o el funcionamiento del servicio, incluyendo intentos de manipulación técnica, evasión de controles o acciones orientadas a saturar sistemas y afectar la experiencia de la comunidad.",
    ],
  },
  {
    id: "politica-de-resenas-y-opiniones-sobre-docentes",
    title: "Política de reseñas y opiniones sobre docentes",
    paragraphs: [
      "Las reseñas sobre docentes están permitidas porque pueden aportar orientación académica entre estudiantes, siempre y cuando se centren en la experiencia del curso, abarcando aspectos como la claridad de explicación, la metodología, la evaluación, el nivel de exigencia, la retroalimentación y la organización general.",
      "Estas opiniones deben redactarse con respeto y mantenerse estrictamente dentro del ámbito académico, por lo que no se admitirán ataques personales, burlas, señalamientos sobre la vida privada ni acusaciones graves sin sustento verificable, prohibiéndose además el uso de este espacio para desprestigiar, humillar o dañar injustamente la reputación de cualquier persona.",
      "Si una reseña infringe estos criterios o existe un riesgo claro para la dignidad, la intimidad o la reputación de alguien, será inmediatamente rechazada o retirada según corresponda.",
    ],
  },
  {
    id: "politica-sobre-materiales-academicos",
    title: "Política sobre materiales académicos, exámenes, prácticas y proyectos",
    paragraphs: [
      "Los materiales históricos de estudio solo podrán compartirse cuando quien los publica tenga derecho suficiente para hacerlo y su difusión no comprometa procesos de evaluación actuales ni reglas específicas del curso, recordando que el simple hecho de tener acceso a un archivo no implica por sí solo la autorización para publicarlo.",
      "Queda prohibido subir evaluaciones vigentes, bancos de respuestas, soluciones oficiales no autorizadas, entregables de terceros, proyectos para copiar, filtraciones, contenido restringido por el curso o cualquier material que facilite el fraude académico, plagio o suplantación.",
      "En caso de que una evaluación o material académico infrinja alguna norma, ya sea por plagio, filtración, confidencialidad, privacidad, autoría o afectación a la integridad académica, podrá ser rechazado, ocultado o borrado de forma definitiva.",
    ],
  },
  {
    id: "propiedad-intelectual-y-derechos-sobre-el-contenido",
    title: "Propiedad intelectual y derechos sobre el contenido",
    paragraphs: [
      "Cada usuario conserva la titularidad de los derechos que legalmente le correspondan sobre el contenido que publica, entendiendo que compartir material en este espacio no implica ceder la autoría ni transferir de forma total los derechos patrimoniales o morales correspondientes.",
      "Para hacer posible el funcionamiento del servicio, quien publica concede una licencia limitada, no exclusiva y revocable que permite alojar, mostrar, ordenar, indexar, procesar técnicamente, moderar y retirar contenido cuando ello sea necesario para la operación, la seguridad o el cumplimiento de esta política, limitándose esta concesión al propósito operativo de la plataforma sin autorizar en ningún momento una apropiación indebida del contenido.",
    ],
  },
  {
    id: "privacidad-y-tratamiento-de-datos-personales",
    title: "Privacidad y tratamiento de datos personales",
    paragraphs: [
      "El tratamiento de datos personales se rige por estrictos criterios de minimización, finalidad específica y confidencialidad, por lo que las reseñas, evaluaciones y reportes se reciben de forma totalmente anónima sin que sus datos de autoría sean almacenados o vinculados en ningún lugar del sistema.",
      "En caso de que una persona decida registrarse, los únicos datos que podrán recopilarse incluyen su información básica de cuenta junto con los registros técnicos de acceso necesarios para operar el servicio, garantizando que elementos como los horarios guardados o el avance en el plan de estudios sean de acceso estrictamente privado y no visibles para otros miembros de la comunidad.",
      "Quien utilice el servicio tendrá siempre la posibilidad de solicitar la corrección, actualización o eliminación de sus datos personales, entendiendo que cierta información técnica indispensable podría llegar a conservarse por un plazo razonable únicamente cuando resulte necesaria para garantizar la seguridad o resolver disputas.",
      "Aunque se adoptan diversas medidas de seguridad para proteger la información, ningún sistema en internet ofrece una garantía absoluta frente a incidentes o accesos indebidos, razón por la cual se recomienda enfáticamente no publicar datos sensibles ni compartir información privada que no sea indispensable para los fines académicos de la plataforma.",
    ],
  },
  {
    id: "moderacion-reportes-y-retiro-de-contenido",
    title: "Moderación, reportes y retiro de contenido",
    paragraphs: [
      "Con el fin de proteger a la comunidad y reducir daños, el contenido podrá ser revisado, ocultado temporalmente, limitado en visibilidad o retirado cuando exista incumplimiento de estas reglas o un riesgo relevante para personas, derechos o procesos académicos.",
      "Asimismo, se atenderán reportes relacionados con privacidad, propiedad intelectual, contenido ofensivo, fraude académico, uso indebido de datos y otras infracciones, evaluando en cada análisis el contexto, la evidencia disponible, la gravedad de los hechos, la recurrencia y el posible impacto sobre terceros.",
      "Cuando la situación lo requiera, podrán adoptarse medidas rápidas orientadas a evitar daños mayores antes de que concluya toda la revisión, de modo que, una vez analizado el caso completo, la administración determine si mantiene, ajusta o revoca la medida aplicada sobre el contenido.",
    ],
  },
  {
    id: "medidas-por-incumplimiento",
    title: "Criterios de rechazo o retiro",
    paragraphs: [
      "Dado que las reseñas y evaluaciones se reciben de forma anónima, la moderación se centra en revisar, rechazar, ocultar o retirar el contenido con el objetivo principal de evitar publicaciones que dañen a terceros, comprometan derechos o afecten la integridad académica.",
      "En consecuencia, según cada situación, podrán adoptarse una o varias de las siguientes acciones sobre el material:",
    ],
    bullets: [
      "Rechazo de una reseña que infrinja los criterios establecidos.",
      "Rechazo, ocultamiento o eliminación de una evaluación que infrinja normas académicas, de privacidad, autoría o propiedad intelectual.",
      "Retiro preventivo de contenido cuando exista un reclamo razonable o una situación urgente.",
      "Mantenimiento del contenido cuando la revisión no evidencie incumplimiento suficiente.",
    ],
  },
  {
    id: "codigo-abierto-y-licencia",
    title: "Código abierto y licencia",
    paragraphs: [
      <>
        Claustrum es un proyecto de código abierto cuyo código fuente está disponible públicamente
        en{" "}
        <a
          href="https://github.com/mau671/claustrum"
          target="_blank"
          rel="noopener noreferrer"
          className="text-primary font-medium hover:underline"
        >
          github.com/mau671/claustrum
        </a>
        .
      </>,
      "El proyecto se distribuye bajo una licencia MIT, la cual permite usar, copiar, modificar y distribuir el código conforme a los términos de dicha licencia.",
    ],
  },
  {
    id: "limitacion-de-responsabilidad",
    title: "Limitación de responsabilidad",
    paragraphs: [
      "Este servicio funciona como una herramienta de apoyo académico e informativo construida con aportes de la comunidad, motivo por el cual, dada su propia naturaleza, no es posible garantizar que todo el contenido publicado por terceros sea exacto, vigente, completo, autorizado o aceptado por instancias institucionales.",
      "Cada usuario debe verificar la información relevante antes de tomar decisiones académicas importantes, especialmente cuando existan canales oficiales para su confirmación, y si bien la administración actúa de buena fe para prevenir abusos y atender incidentes, no puede asumir una responsabilidad ilimitada por actuaciones de terceros ni por eventos que escapen a su control razonable.",
    ],
  },
  {
    id: "modificaciones-de-la-politica",
    title: "Modificaciones de la política",
    paragraphs: [
      "Esta política podrá actualizarse cuando sea necesario mejorar reglas de convivencia, reforzar controles de privacidad, responder a nuevos riesgos o ajustar el funcionamiento del servicio, realizando siempre los cambios con un enfoque preventivo orientado a buscar mayor claridad para la comunidad usuaria.",
      "En caso de presentarse una modificación sustancial, se procurará comunicarla a través de medios razonables dentro de la plataforma, entendiéndose el uso continuado de la misma, después de publicada una nueva versión, como una aceptación explícita de las condiciones vigentes.",
    ],
  },
  {
    id: "contacto-y-solicitudes",
    title: "Contacto y solicitudes",
    paragraphs: [
      <>
        Para reportes, solicitudes de retiro de contenido, ejercicio de derechos sobre datos
        personales o consultas generales relacionadas con la plataforma, se pone a disposición el
        correo <EmailContact />, el cual también podrá utilizarse si alguna autoridad competente
        requiere la eliminación de contenido o necesita comunicarse por una situación específica.
      </>,
      "Con el fin de facilitar una atención mucho más ágil, se solicita que toda comunicación incluya la identificación clara del contenido involucrado, el motivo del reclamo y, cuando sea posible, evidencia básica de respaldo.",
    ],
  },
];

export function PoliciesPage() {
  const { hash } = useLocation();

  useEffect(() => {
    if (!hash) return;

    const targetId = hash.startsWith("#") ? hash.slice(1) : hash;
    if (!targetId) return;

    requestAnimationFrame(() => {
      const el = document.getElementById(targetId);
      if (!el) return;
      el.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  }, [hash]);

  return (
    <div className="flex flex-1 justify-center px-6 py-8 sm:px-8 lg:px-12 lg:py-10">
      <div className="w-full max-w-6xl space-y-6 lg:space-y-12">
        <header className="max-w-4xl space-y-4">
          <h1 className="text-3xl font-semibold tracking-tight lg:text-4xl">
            Reglamento, políticas de uso y privacidad
          </h1>
        </header>

        <div className="space-y-10">
          {sections.map((section) => (
            <section
              key={section.title}
              id={section.id}
              className="grid scroll-mt-24 gap-4 border-t pt-8 lg:grid-cols-[minmax(0,280px)_minmax(0,1fr)] lg:gap-8"
            >
              <h2 className="text-xl font-semibold tracking-tight lg:text-2xl">
                <a href={`#${section.id}`} className="hover:text-primary transition-colors">
                  {section.title}
                </a>
              </h2>

              <div className="space-y-5">
                {section.paragraphs.map((paragraph, idx) => (
                  <p
                    key={idx}
                    className="text-foreground/90 max-w-4xl text-base leading-8 lg:text-lg"
                  >
                    {paragraph}
                  </p>
                ))}

                {section.bullets ? (
                  <ul className="text-foreground/90 max-w-4xl list-disc space-y-3 pl-6 text-base leading-8 lg:text-lg">
                    {section.bullets.map((item, idx) => (
                      <li key={idx}>{item}</li>
                    ))}
                  </ul>
                ) : null}
              </div>
            </section>
          ))}
        </div>
      </div>
    </div>
  );
}
