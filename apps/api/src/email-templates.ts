type AuthEmailType = "email-verification" | "magic-link" | "reset-password";

interface AuthEmailTemplateInput {
  type: AuthEmailType;
  email: string;
  url: string;
}

const emailConfirmationTemplate = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Confirma tu correo</title>
  <style>
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
    a { color: #171717; text-decoration: none; }
    a:hover { text-decoration: underline; }
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; }
      .content-padding { padding: 24px 20px !important; }
      .button { width: 100% !important; max-width: 280px !important; }
      .mobile-stack { display: block !important; width: 100% !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f5f5f5; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;">
  <div style="display: none; max-height: 0; overflow: hidden;">Verifica tu dirección de correo para comenzar con tu cuenta.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f5f5f5;">
    <tr><td align="center" style="padding: 40px 10px;">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" class="email-container" width="600" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); max-width: 600px;">
        <tr><td style="padding: 40px 40px 20px 40px; text-align: center;"><h1 style="margin: 0; font-size: 24px; font-weight: 600; color: #171717;">Verifica tu correo</h1></td></tr>
        <tr><td class="content-padding" style="padding: 0 40px 24px 40px;">
          <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr><td style="text-align: center; padding-bottom: 24px;"><p style="margin: 0 0 10px 0; font-size: 16px; line-height: 1.6; color: #525252;">¡Bienvenido a <strong>Claustrum</strong>!</p><p style="margin: 0; font-size: 16px; line-height: 1.6; color: #525252;">Confirma tu correo para activar tu cuenta y empezar a organizar tu avance académico.</p></td></tr>
            <tr><td align="center" style="padding-bottom: 24px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0"><tr><td align="center" style="border-radius: 8px; background: #111827;"><a href="{{ .ConfirmationURL }}" target="_blank" class="button" style="font-size: 16px; font-weight: 500; color: #ffffff; text-decoration: none; padding: 14px 32px; display: inline-block; border-radius: 8px;">Verificar mi correo</a></td></tr></table></td></tr>
            <tr><td style="text-align: center;"><p style="margin: 0; font-size: 14px; color: #737373; line-height: 1.5;">Si el botón no funciona, copia y pega este enlace en tu navegador:<br><a href="{{ .ConfirmationURL }}" target="_blank" style="color: #171717; word-break: break-all; font-size: 12px;">{{ .ConfirmationURL }}</a></p></td></tr>
          </table>
        </td></tr>
        <tr><td style="padding: 0 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="border-top: 1px solid #e5e5e5;"></td></tr></table></td></tr>
        <tr><td style="padding: 24px 40px 40px 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="text-align: center;"><p style="margin: 0 0 8px 0; font-size: 14px; color: #525252;">Este enlace expirará en 24 horas por tu seguridad.</p><p style="margin: 0; font-size: 13px; color: #a3a3a3;">Si no creaste una cuenta con nosotros, puedes ignorar este correo de forma segura.</p></td></tr></table></td></tr>
      </table>
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="padding: 30px 0; text-align: center;"><p style="margin: 0; font-size: 12px; color: #a3a3a3;">© 2026 Claustrum. Todos los derechos reservados.</p></td></tr></table>
    </td></tr>
  </table>
</body>
</html>`;

const magicLinkTemplate = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Tu enlace mágico</title>
  <style>
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
    a { color: #171717; text-decoration: none; }
    a:hover { text-decoration: underline; }
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; }
      .content-padding { padding: 24px 20px !important; }
      .button { width: 100% !important; max-width: 280px !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f5f5f5; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;">
  <div style="display: none; max-height: 0; overflow: hidden;">Inicia sesión con tu enlace mágico.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f5f5f5;"><tr><td align="center" style="padding: 40px 10px;">
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" class="email-container" width="600" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); max-width: 600px;">
      <tr><td style="padding: 40px 40px 20px 40px; text-align: center;"><h1 style="margin: 0; font-size: 24px; font-weight: 600; color: #171717;">Tu enlace mágico</h1></td></tr>
      <tr><td class="content-padding" style="padding: 0 40px 24px 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr><td style="text-align: center; padding-bottom: 24px;"><p style="margin: 0 0 8px 0; font-size: 16px; line-height: 1.6; color: #525252;">Inicia sesión con un clic. No necesitas contraseña.</p><p style="margin: 0; font-size: 14px; color: #737373;">Este enlace es para: <strong>{{ .Email }}</strong></p></td></tr>
        <tr><td align="center" style="padding-bottom: 24px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0"><tr><td align="center" style="border-radius: 8px; background: #171717;"><a href="{{ .ConfirmationURL }}" target="_blank" class="button" style="font-size: 16px; font-weight: 500; color: #ffffff; text-decoration: none; padding: 14px 32px; display: inline-block; border-radius: 8px;">Iniciar sesión</a></td></tr></table></td></tr>
        <tr><td style="text-align: center;"><p style="margin: 0; font-size: 14px; color: #737373; line-height: 1.5;">Si el botón no funciona, copia y pega este enlace en tu navegador:<br><a href="{{ .ConfirmationURL }}" target="_blank" style="color: #171717; word-break: break-all; font-size: 12px;">{{ .ConfirmationURL }}</a></p></td></tr>
      </table></td></tr>
      <tr><td style="padding: 0 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="border-top: 1px solid #e5e5e5;"></td></tr></table></td></tr>
      <tr><td style="padding: 24px 40px 40px 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="text-align: center;"><p style="margin: 0 0 8px 0; font-size: 14px; color: #525252;">Este enlace expirará en 1 hora por seguridad.</p><p style="margin: 0; font-size: 13px; color: #a3a3a3;">Si no solicitaste este enlace, puedes ignorar este correo.</p></td></tr></table></td></tr>
    </table>
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="padding: 30px 0; text-align: center;"><p style="margin: 0; font-size: 12px; color: #a3a3a3;">© 2026 Claustrum. Todos los derechos reservados.</p></td></tr></table>
  </td></tr></table>
</body>
</html>`;

const passwordRecoveryTemplate = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Restablece tu contraseña</title>
  <style>
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
    a { color: #171717; text-decoration: none; }
    a:hover { text-decoration: underline; }
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; }
      .content-padding { padding: 24px 20px !important; }
      .button { width: 100% !important; max-width: 280px !important; }
      .mobile-stack { display: block !important; width: 100% !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f5f5f5; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;">
  <div style="display: none; max-height: 0; overflow: hidden;">Restablece tu contraseña con el enlace de recuperación.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f5f5f5;"><tr><td align="center" style="padding: 40px 10px;">
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" class="email-container" width="600" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); max-width: 600px;">
      <tr><td style="padding: 40px 40px 20px 40px; text-align: center;"><h1 style="margin: 0; font-size: 24px; font-weight: 600; color: #171717;">Restablece tu contraseña</h1></td></tr>
      <tr><td class="content-padding" style="padding: 0 40px 24px 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr><td style="text-align: center; padding-bottom: 24px;"><p style="margin: 0 0 8px 0; font-size: 16px; line-height: 1.6; color: #525252;">Recibimos una solicitud para restablecer la contraseña de:</p><p style="margin: 0; font-size: 16px; font-weight: 600; color: #171717;">{{ .Email }}</p></td></tr>
        <tr><td style="text-align: center; padding-bottom: 24px;"><p style="margin: 0; font-size: 16px; line-height: 1.6; color: #525252;">Haz clic en el botón para crear una nueva contraseña.</p></td></tr>
        <tr><td align="center" style="padding-bottom: 24px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0"><tr><td align="center" style="border-radius: 8px; background: #171717;"><a href="{{ .ConfirmationURL }}" target="_blank" class="button" style="font-size: 16px; font-weight: 500; color: #ffffff; text-decoration: none; padding: 14px 32px; display: inline-block; border-radius: 8px;">Crear nueva contraseña</a></td></tr></table></td></tr>
        <tr><td style="text-align: center;"><p style="margin: 0; font-size: 14px; color: #737373; line-height: 1.5;">Si el botón no funciona, copia y pega este enlace en tu navegador:<br><a href="{{ .ConfirmationURL }}" target="_blank" style="color: #171717; word-break: break-all; font-size: 12px;">{{ .ConfirmationURL }}</a></p></td></tr>
      </table></td></tr>
      <tr><td style="padding: 0 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="border-top: 1px solid #e5e5e5;"></td></tr></table></td></tr>
      <tr><td style="padding: 0 40px 40px 40px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="text-align: center;"><p style="margin: 0 0 8px 0; font-size: 14px; color: #525252;">Este enlace expirará en 1 hora por seguridad.</p><p style="margin: 0; font-size: 13px; color: #a3a3a3;">Si no solicitaste este cambio, puedes ignorar este correo.</p></td></tr></table></td></tr>
    </table>
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="padding: 30px 0; text-align: center;"><p style="margin: 0; font-size: 12px; color: #a3a3a3;">© 2026 Claustrum. Todos los derechos reservados.</p></td></tr></table>
  </td></tr></table>
</body>
</html>`;

const templates: Record<AuthEmailType, string> = {
  "email-verification": emailConfirmationTemplate,
  "magic-link": magicLinkTemplate,
  "reset-password": passwordRecoveryTemplate,
};

function escapeHtml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

export function renderAuthEmailTemplate({ type, email, url }: AuthEmailTemplateInput): string {
  return templates[type]
    .replaceAll("{{ .ConfirmationURL }}", escapeHtml(url))
    .replaceAll("{{ .Email }}", escapeHtml(email));
}
