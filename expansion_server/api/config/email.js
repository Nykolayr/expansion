const nodemailer = require('nodemailer');

function createTransporter() {
  if (process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS) {
    const config = {
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT || '587', 10),
      secure: process.env.SMTP_SECURE === 'true',
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    };

    if (process.env.SMTP_HOST.includes('gmail.com')) {
      config.requireTLS = true;
      config.secure = false;
      config.tls = {
        ciphers: 'SSLv3',
        rejectUnauthorized: false,
      };
    }

    return nodemailer.createTransport(config);
  }

  if (process.env.SENDGRID_API_KEY) {
    return nodemailer.createTransport({
      service: 'SendGrid',
      auth: {
        user: 'apikey',
        pass: process.env.SENDGRID_API_KEY,
      },
    });
  }

  console.warn(
    'Email not configured. Set SMTP_HOST, SMTP_USER, SMTP_PASS in .env',
  );
  return null;
}

const transporter = createTransporter();

function appName() {
  return process.env.APP_NAME || 'Expansion';
}

function fromEmail() {
  return process.env.EMAIL_FROM || process.env.SMTP_USER || 'noreply@expansion.local';
}

function replacePlaceholders(str, { code }) {
  if (typeof str !== 'string') return str;
  return str.replace(/\{\{code\}\}/g, code);
}

function defaultVerificationHtml(code) {
  const name = appName();
  return `
    <!DOCTYPE html>
    <html><head><meta charset="utf-8"></head>
    <body style="font-family:Arial,sans-serif;line-height:1.6;color:#333;">
      <div style="max-width:600px;margin:0 auto;padding:20px;">
        <h2>${name} — код подтверждения</h2>
        <p>Используйте код для завершения регистрации:</p>
        <p style="font-size:32px;font-weight:bold;letter-spacing:4px;">${code}</p>
        <p>Код действует 15 минут.</p>
      </div>
    </body></html>
  `.trim();
}

function defaultVerificationText(code) {
  const name = appName();
  return `Код подтверждения ${name}: ${code}\n\nКод действует 15 минут.`;
}

function defaultResetHtml(code) {
  const name = appName();
  return `
    <!DOCTYPE html>
    <html><head><meta charset="utf-8"></head>
    <body style="font-family:Arial,sans-serif;line-height:1.6;color:#333;">
      <div style="max-width:600px;margin:0 auto;padding:20px;">
        <h2>${name} — сброс пароля</h2>
        <p>Код для смены пароля:</p>
        <p style="font-size:32px;font-weight:bold;letter-spacing:4px;">${code}</p>
        <p>Код действует 15 минут. Если вы не запрашивали сброс — проигнорируйте письмо.</p>
      </div>
    </body></html>
  `.trim();
}

function defaultResetText(code) {
  const name = appName();
  return `Код сброса пароля ${name}: ${code}\n\nКод действует 15 минут.`;
}

async function sendMail({ to, subject, html, text }) {
  if (!transporter) {
    return {
      success: false,
      error: 'Email transporter not configured',
      code: 'EMAIL_NOT_CONFIGURED',
    };
  }

  try {
    const info = await transporter.sendMail({
      from: `"${appName()}" <${fromEmail()}>`,
      to,
      subject,
      html,
      text,
    });
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error('Email send failed:', error.message);
    return {
      success: false,
      error: error.message,
      code: error.code || 'EMAIL_SEND_FAILED',
    };
  }
}

async function sendVerificationCode(email, code, options = {}) {
  const subject =
    options.subject != null
      ? replacePlaceholders(options.subject, { code })
      : `Код подтверждения — ${appName()}`;
  const html =
    options.html != null
      ? replacePlaceholders(options.html, { code })
      : defaultVerificationHtml(code);
  const text =
    options.text != null
      ? replacePlaceholders(options.text, { code })
      : defaultVerificationText(code);

  return sendMail({ to: email, subject, html, text });
}

async function sendPasswordResetCode(email, code, options = {}) {
  const subject =
    options.subject != null
      ? replacePlaceholders(options.subject, { code })
      : `Сброс пароля — ${appName()}`;
  const html =
    options.html != null
      ? replacePlaceholders(options.html, { code })
      : defaultResetHtml(code);
  const text =
    options.text != null
      ? replacePlaceholders(options.text, { code })
      : defaultResetText(code);

  return sendMail({ to: email, subject, html, text });
}

module.exports = {
  sendVerificationCode,
  sendPasswordResetCode,
  transporter,
};
