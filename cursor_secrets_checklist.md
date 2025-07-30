# Cursor Secrets Prevention Checklist

## Pre-Development Setup

### 1. Environment Configuration
- [ ] Set up `.env` files for local development (never commit these)
- [ ] Create `.env.example` with placeholder values for team reference
- [ ] Add `.env*` to `.gitignore` (except `.env.example`)
- [ ] Configure environment-specific settings (dev/staging/prod)

### 2. Git Configuration
- [ ] Set up pre-commit hooks for secret scanning
- [ ] Configure `.gitignore` to exclude sensitive files
- [ ] Enable branch protection rules for main/master branches
- [ ] Set up required pull request reviews

### 3. IDE/Editor Setup
- [ ] Install secret scanning extensions (e.g., GitGuardian, TruffleHog)
- [ ] Configure Cursor to highlight potential secrets
- [ ] Set up linting rules for secret detection
- [ ] Enable real-time scanning for API keys, passwords, tokens

## During Development

### 4. Code Writing Practices
- [ ] Never hardcode secrets directly in source code
- [ ] Use environment variables for all sensitive data
- [ ] Implement proper input validation for user data
- [ ] Use parameterized queries to prevent SQL injection
- [ ] Sanitize all user inputs before processing

### 5. API Key Management
- [ ] Store API keys in environment variables only
- [ ] Use different keys for different environments
- [ ] Implement key rotation procedures
- [ ] Use least-privilege access for API permissions
- [ ] Monitor API key usage for anomalies

### 6. Database Security
- [ ] Use connection strings from environment variables
- [ ] Implement proper database user permissions
- [ ] Use parameterized queries exclusively
- [ ] Encrypt sensitive data at rest
- [ ] Implement proper backup encryption

### 7. Authentication & Authorization
- [ ] Store user passwords as hashed values only
- [ ] Implement proper session management
- [ ] Use secure token storage (httpOnly cookies, secure headers)
- [ ] Implement proper logout procedures
- [ ] Use OAuth2/OpenID Connect when possible

## Before Committing Code

### 8. Pre-Commit Checks
- [ ] Run secret scanning tools (TruffleHog, GitGuardian)
- [ ] Check for hardcoded credentials in all files
- [ ] Verify no API keys in comments or documentation
- [ ] Ensure no secrets in log statements
- [ ] Check for exposed secrets in error messages

### 9. Code Review Checklist
- [ ] Review all new environment variables
- [ ] Check for proper secret handling in new code
- [ ] Verify no secrets in test data
- [ ] Ensure proper error handling doesn't expose secrets
- [ ] Review authentication/authorization logic

### 10. Documentation Review
- [ ] Ensure no real credentials in README files
- [ ] Check that setup instructions use placeholder values
- [ ] Verify no secrets in code comments
- [ ] Review API documentation for exposed endpoints
- [ ] Check configuration examples for real values

## Deployment & Production

### 11. Environment Management
- [ ] Use secure secret management services (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault)
- [ ] Implement proper CI/CD secret injection
- [ ] Use different secrets for each environment
- [ ] Implement secret rotation procedures
- [ ] Monitor secret access and usage

### 12. Infrastructure Security
- [ ] Secure all configuration files
- [ ] Use encrypted communication (HTTPS, TLS)
- [ ] Implement proper network security
- [ ] Use secure container practices
- [ ] Implement proper logging without sensitive data

### 13. Monitoring & Alerting
- [ ] Set up alerts for suspicious secret usage
- [ ] Monitor for unauthorized access attempts
- [ ] Implement proper audit logging
- [ ] Set up alerts for secret exposure in logs
- [ ] Monitor API key usage patterns

## Emergency Response

### 14. Incident Response
- [ ] Have a plan for secret rotation if compromised
- [ ] Document incident response procedures
- [ ] Set up emergency contact procedures
- [ ] Have backup authentication methods ready
- [ ] Document rollback procedures

### 15. Recovery Procedures
- [ ] Document how to revoke compromised secrets
- [ ] Have procedures for updating dependent services
- [ ] Document communication procedures for stakeholders
- [ ] Have backup systems ready
- [ ] Document lessons learned process

## Regular Maintenance

### 16. Ongoing Security
- [ ] Regularly rotate secrets and API keys
- [ ] Review and update access permissions
- [ ] Monitor for new security vulnerabilities
- [ ] Update security tools and extensions
- [ ] Conduct regular security audits

### 17. Team Training
- [ ] Train team on secure coding practices
- [ ] Review security incidents and lessons learned
- [ ] Update security procedures based on new threats
- [ ] Conduct regular security awareness training
- [ ] Keep team updated on new security tools

## Cursor-Specific Considerations

### 18. AI Assistant Security
- [ ] Never share real secrets with AI assistants
- [ ] Use placeholder values when asking for help
- [ ] Review AI-generated code for security issues
- [ ] Be cautious with code explanations that might include secrets
- [ ] Use AI tools that respect privacy and security

### 19. Workspace Security
- [ ] Secure your Cursor workspace
- [ ] Use workspace-specific environment files
- [ ] Be careful with shared workspaces
- [ ] Review workspace settings for security
- [ ] Use proper access controls for team workspaces

## Quick Daily Checklist

### 20. Daily Security Habits
- [ ] Check for any new secrets added to code
- [ ] Verify environment variables are properly set
- [ ] Review any new API integrations
- [ ] Check logs for potential secret exposure
- [ ] Verify no secrets in recent commits

---

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Security Best Practices](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [Azure Security Documentation](https://docs.microsoft.com/en-us/azure/security/)

## Emergency Contacts

- Security Team: [Add contact information]
- IT Support: [Add contact information]
- Incident Response: [Add contact information]

---

**Remember**: When in doubt, treat any piece of information as potentially sensitive and handle it securely. It's always better to be overly cautious than to risk a security breach. 