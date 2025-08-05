# Quick-start: Context Engineering with Cursor

Get up and running with context engineering in Cursor IDE in under 10 minutes. This guide provides immediate, practical steps to improve your AI-assisted development workflow.

## 🚀 5-Minute Setup

### Step 1: Create Your First Context File
Create a `.cursor/rules.md` file in your project root:

```bash
mkdir .cursor
touch .cursor/rules.md
```

### Step 2: Add Basic Project Context
Add the following content to `.cursor/rules.md`:

```markdown
# Project Rules for AI Assistant

## Technology Stack
- [Your primary language/framework]
- [Your database]
- [Your testing framework]
- [Your styling solution]

## Coding Standards
- Use [your preferred style] (e.g., functional components, TypeScript)
- Follow [your linting rules] (e.g., ESLint, Prettier)
- Use [your naming conventions] (e.g., camelCase, PascalCase)
- Write [your documentation style] (e.g., JSDoc, inline comments)

## Architecture Patterns
- [Your folder structure] (e.g., feature-based, layer-based)
- [Your API patterns] (e.g., REST, GraphQL)
- [Your state management] (e.g., Redux, Context API)
- [Your error handling] (e.g., try-catch, error boundaries)

## Examples
Here's an example of a good component:
```typescript
interface UserCardProps {
  user: User;
  onEdit: (user: User) => void;
}

export const UserCard: React.FC<UserCardProps> = ({ user, onEdit }) => {
  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <button onClick={() => onEdit(user)}>Edit</button>
    </div>
  );
};
```
```

### Step 3: Test Your Context
Open Cursor IDE and try a simple prompt:

```
Create a new React component for displaying a product card
```

You should see the AI generate code that follows your specified patterns.

## 🎯 Immediate Improvements

### Better Prompts with Context
**Before** (without context):
```
Write a function to handle user authentication
```

**After** (with context):
```
Write a function to handle user authentication that follows our project's patterns:
- Use TypeScript with proper types
- Include error handling
- Follow our API structure
- Add JSDoc documentation
```

### Feature-Level Context
When working on a specific feature, open relevant files in your editor:

1. **Open related components** that the AI should reference
2. **Include API schemas** or data models
3. **Show existing patterns** you want to follow

### Task-Level Context
Be specific about your immediate goal:

```
I need to add a new field to the user profile form. 
The field should:
- Be called "phoneNumber"
- Accept international phone numbers
- Include validation
- Update the existing User interface
- Follow our form component patterns
```

## 📈 Quick Wins

### 1. Reduced Refactoring
With proper context, you'll see **60-80% reduction** in manual code changes.

### 2. Faster Development
AI will generate code that matches your patterns immediately, not after multiple iterations.

### 3. Better Consistency
All team members will generate code that follows the same standards.

### 4. Improved Onboarding
New developers can leverage the same context as experienced team members.

## 🛠️ Advanced Setup

### Environment-Specific Context
Create different context files for different environments:

```bash
.cursor/
├── rules.md              # General project rules
├── rules.frontend.md     # Frontend-specific patterns
├── rules.backend.md      # Backend-specific patterns
└── rules.testing.md      # Testing patterns
```

### Team-Shared Context
Store context files in version control so the entire team benefits:

```bash
git add .cursor/rules.md
git commit -m "Add AI context rules for project standards"
```

### Context Validation
Regularly review and update your context:

- **Monthly**: Review and update technology stack
- **Weekly**: Add new patterns and examples
- **Daily**: Refine based on AI outputs

## 🎯 Common Patterns

### React/TypeScript Project
```markdown
# React/TypeScript Project Rules

## Component Patterns
- Use functional components with hooks
- Prefer TypeScript over JavaScript
- Use proper prop interfaces
- Include error boundaries

## State Management
- Use React Context for global state
- Prefer local state when possible
- Use custom hooks for complex logic

## Styling
- Use Tailwind CSS classes
- Follow mobile-first responsive design
- Use CSS variables for theming
```

### Node.js/Express Project
```markdown
# Node.js/Express Project Rules

## API Patterns
- Use async/await for database operations
- Include proper error handling
- Use JWT for authentication
- Follow RESTful conventions

## Database
- Use Prisma ORM
- Include proper validation
- Use transactions for complex operations

## Testing
- Use Jest for unit tests
- Use Supertest for API tests
- Mock external dependencies
```

## 🔧 Troubleshooting

### AI Ignores Your Context
- **Check file location**: Ensure `.cursor/rules.md` is in project root
- **Verify syntax**: Check for markdown formatting errors
- **Restart Cursor**: Sometimes context needs a fresh start
- **Be more specific**: Add concrete examples to your context

### Inconsistent Outputs
- **Add more examples**: Show exactly what you want
- **Be explicit**: Don't assume the AI knows your conventions
- **Iterate**: Refine context based on actual outputs

### Context Too Broad
- **Be specific**: Include concrete patterns and examples
- **Use multiple files**: Split context by domain or concern
- **Update regularly**: Keep context current with your project

## 📖 Next Steps

- **[Context Engineering Deep Dive](context_engineering.md)** - Understand the theory behind context engineering
- **[Advanced Prompting](advanced_prompting.md)** - Combine context with sophisticated prompting techniques
- **[AI Workflows](ai_workflows/index.md)** - Real-world implementation examples

## 🎯 Success Metrics

Track these metrics to measure your context engineering success:

- **Time to first working code**: Should decrease significantly
- **Number of iterations**: Should reduce from 3-5 to 1-2
- **Code review comments**: Should focus on logic, not style
- **Team consistency**: All developers should generate similar patterns

---

**Ready to see immediate improvements?** Start with the 5-minute setup above, then explore **[Context Engineering](context_engineering.md)** for deeper understanding.
