# Example Setup: Full-Stack Developer

This is an example CLAUDE.md configuration for a full-stack web developer.

## User Profile
- **Name**: Alex Developer
- **Primary Use Case**: Full-stack web development (React + Node.js)
- **Primary Email**: alex@example.com

## Current Week Focus

**Week of**: 2025-11-11 (Week 45)
**Primary Project**: E-commerce Platform Redesign
**Status**: Building new checkout flow with Stripe integration
**Next Actions**:
- [ ] Complete payment integration tests
- [ ] Implement order confirmation emails
- [ ] Deploy to staging environment

## Default File Locations

### Primary Storage
- **Projects**: ~/Code/projects/
- **Personal**: ~/Documents/
- **Client Work**: ~/Code/clients/

## Active Projects

### E-commerce Platform
- **Tech Stack**: Next.js 14, TypeScript, PostgreSQL, Stripe
- **Location**: ~/Code/projects/ecommerce-platform
- **Status**: Active development
- **Key Files**:
  - `src/app/checkout/` - Checkout flow
  - `src/lib/stripe.ts` - Stripe integration
  - `tests/e2e/checkout.spec.ts` - E2E tests

### Personal Portfolio
- **Tech Stack**: Astro, Tailwind CSS
- **Location**: ~/Code/projects/portfolio
- **Status**: Maintenance mode
- **Deployed**: https://alex-dev.com

### Client: SaaS Dashboard
- **Tech Stack**: React, Node.js, MongoDB
- **Location**: ~/Code/clients/saas-dashboard
- **Status**: Active
- **Client**: TechStartup Inc.

## Custom Commands

### Development Workflow
```bash
# Project shortcuts
alias ecom='cd ~/Code/projects/ecommerce-platform && code .'
alias port='cd ~/Code/projects/portfolio && code .'

# Quick servers
alias dev-ecom='cd ~/Code/projects/ecommerce-platform && npm run dev'
alias test-ecom='cd ~/Code/projects/ecommerce-platform && npm test -- --watch'

# Database
alias db-local='psql ecommerce_dev'
alias db-migrate='npm run db:migrate'
```

### Claude Commands
```bash
# Quick context loading
> Load context: E-commerce project

# Feature planning
> /plan-feature Abandoned cart recovery emails

# Code reviews
> /code-review @src/lib/stripe.ts

# Research
> /research Best practices for Stripe webhook handling
```

## Tool Integrations

### MCP Servers Enabled
- **Perplexity**: For researching best practices and current trends
- **Puppeteer**: For E2E testing and screenshot generation
- **Gmail**: For client communication
- **Airtable**: For project and task tracking

### Development Tools
- **Editor**: VSCode
- **Terminal**: iTerm2 with tmux
- **Database Client**: TablePlus
- **API Testing**: Bruno (Postman alternative)

## iTerm2 Layouts

### Full-Stack Development Layout
```
┌─────────────────────────┬─────────────┐
│                         │             │
│   Claude Code           │  Dev Server │
│   (Main coding)         │  (Next.js)  │
│                         │             │
├─────────────────────────┼─────────────┤
│                         │             │
│   Test Watcher          │  Database   │
│   (Jest/Vitest)         │  (psql)     │
│                         │             │
└─────────────────────────┴─────────────┘
```

Trigger: `Cmd+Opt+F` (custom keybinding)

## Testing Philosophy

- Write integration tests for critical paths (payment, auth)
- Unit tests for business logic and utilities
- E2E tests for complete user flows
- TDD for complex features
- Visual regression testing for UI components

## Communication Style Preferences

- Be concise and direct
- Prefer showing code examples over explaining
- Reference specific file paths and line numbers
- When stuck, ask for screenshots or error messages
- Use iTerm2 split panes for multi-step debugging

## Weekly Routine

### Monday Morning
- Update Current Week Focus
- Review Airtable tasks
- Plan sprint work

### Friday Afternoon
- Update project documentation
- Review PRs from the week
- Backup code to S3
- Weekly review with Claude

## Automation

### LaunchAgents
- Daily S3 backup at 2 AM
- Weekly dependency updates check
- Monthly cost tracking report

### Git Hooks
- Pre-commit: ESLint + Prettier
- Pre-push: Run tests
- Post-commit: Update task status in Airtable

## Common Patterns

### When Starting a New Feature
```
1. /plan-feature [Feature name]
2. Create feature branch
3. Write tests first (TDD)
4. Implement feature
5. /code-review @src/...
6. Deploy to staging
7. Create PR
```

### When Debugging
```
1. Reproduce the bug
2. Take screenshot (Cmd+Ctrl+Shift+4)
3. Paste error message to Claude
4. Claude suggests split pane for live debugging
5. Fix and add regression test
```

### When Researching
```
1. /research [Topic]
2. Claude uses Perplexity for current info
3. Creates markdown summary
4. Saves to ~/Documents/Research/
5. Reference in project README
```

## Current Tech Stack

### Frontend
- Next.js 14 (App Router)
- TypeScript
- Tailwind CSS
- Radix UI
- React Query
- Zustand (state)

### Backend
- Node.js
- Express
- PostgreSQL
- Prisma ORM
- Redis (caching)
- Stripe (payments)

### Testing
- Vitest (unit)
- Playwright (E2E)
- MSW (API mocking)
- Testing Library

### DevOps
- Vercel (frontend)
- Railway (backend)
- GitHub Actions (CI/CD)
- Sentry (monitoring)

## Performance Targets

- CLAUDE.md: ~600 lines (loads in < 1 second)
- Context load: < 3 seconds
- Session startup: < 1 second
- Token usage: ~5000 tokens (2.5% of 200K)

---

**Last Updated**: 2025-11-11
**Review Schedule**: Weekly (Mondays)
