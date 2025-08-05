# AI Workflows

Concrete step-by-step workflows for common developer activities powered by AI assistants. These proven patterns will accelerate your development process.

## 🎯 Workflow Categories

### Code Generation Workflows
- **Component Creation**: Generate React/Vue/Angular components
- **API Development**: Create REST/GraphQL endpoints
- **Database Operations**: Generate queries and migrations
- **Test Generation**: Create unit and integration tests

### Debugging Workflows
- **Error Analysis**: Diagnose and fix runtime errors
- **Performance Issues**: Identify and resolve bottlenecks
- **Logic Problems**: Debug complex business logic
- **Integration Issues**: Resolve API and service problems

### Refactoring Workflows
- **Code Cleanup**: Improve code quality and readability
- **Architecture Improvements**: Restructure for better maintainability
- **Performance Optimization**: Refactor for better efficiency
- **Security Hardening**: Improve security posture

## 🚀 Code Generation Workflows

### React Component Generation

**Context Setup**:
1. Open your `.cursor/rules.md` with React patterns
2. Have existing components open for reference
3. Include your component library or design system

**Prompt Structure**:
```
Create a React component for [component name] that:
- Accepts [props] as parameters
- Displays [specific content/functionality]
- Uses [styling approach] for styling
- Includes [specific features like validation, error handling]
- Follows our project's patterns for [specific aspect]

Requirements:
- [Specific business requirements]
- [Performance considerations]
- [Accessibility requirements]
- [Testing considerations]
```

**Example**:
```
Create a ProductCard component that:
- Accepts a product object with name, price, image, and description
- Displays the product information in a card layout
- Uses Tailwind CSS for styling
- Includes loading states and error handling
- Follows our project's patterns for TypeScript interfaces

Requirements:
- Must be responsive (mobile-first)
- Include hover effects for better UX
- Support dark mode
- Be accessible with proper ARIA labels
```

### API Endpoint Generation

**Context Setup**:
1. Open your API structure and patterns
2. Include database schemas or models
3. Have authentication/authorization patterns visible

**Prompt Structure**:
```
Create a [HTTP method] endpoint for [resource] that:
- Handles [specific operations]
- Validates [input requirements]
- Returns [expected response format]
- Includes [error handling, logging, etc.]
- Follows our API patterns for [specific aspect]

Database operations:
- [Specific database queries/operations]
- [Transaction handling if needed]
- [Data validation rules]

Security considerations:
- [Authentication requirements]
- [Authorization checks]
- [Input sanitization]
```

**Example**:
```
Create a POST endpoint for user registration that:
- Handles new user creation with email and password
- Validates email format and password strength
- Returns user data with JWT token
- Includes comprehensive error handling and logging
- Follows our API patterns for response formatting

Database operations:
- Check if email already exists
- Hash password using bcrypt
- Create user record with timestamps
- Use database transaction for atomicity

Security considerations:
- Require valid JWT for authenticated endpoints
- Validate input against XSS and injection attacks
- Rate limit registration attempts
```

## 🔍 Debugging Workflows

### Error Analysis Workflow

**Context Setup**:
1. Open the file with the error
2. Include related files and dependencies
3. Have error logs or stack traces visible

**Prompt Structure**:
```
I'm getting this error: [paste error message]

Context:
- File: [file path]
- Function: [function name]
- Related files: [list of related files]

The error occurs when: [describe when it happens]

I've tried: [list attempted solutions]

Please help me:
1. Identify the root cause
2. Suggest a fix
3. Explain why this happened
4. Suggest prevention strategies
```

**Example**:
```
I'm getting this error: "Cannot read property 'name' of undefined"

Context:
- File: src/components/UserProfile.tsx
- Function: renderUserInfo
- Related files: src/types/User.ts, src/hooks/useUser.ts

The error occurs when: The user data hasn't loaded yet but the component tries to render

I've tried: Adding a loading check but it's still happening

Please help me:
1. Identify the root cause
2. Suggest a fix
3. Explain why this happened
4. Suggest prevention strategies
```

### Performance Debugging Workflow

**Context Setup**:
1. Open the problematic component/function
2. Include performance metrics or profiling data
3. Have related dependencies visible

**Prompt Structure**:
```
I'm experiencing performance issues with [component/function]:

Symptoms:
- [Describe the performance problem]
- [When it occurs]
- [ Impact on user experience]

Current implementation:
- [Brief description of current approach]
- [Key code sections]

Performance data:
- [Any metrics, profiling results, or observations]

Please help me:
1. Identify performance bottlenecks
2. Suggest optimization strategies
3. Provide optimized code examples
4. Recommend monitoring approaches
```

## 🔧 Refactoring Workflows

### Code Cleanup Workflow

**Context Setup**:
1. Open the file to be refactored
2. Include coding standards and patterns
3. Have similar well-structured files visible

**Prompt Structure**:
```
Please help me refactor this code to improve:

Current issues:
- [List specific problems]
- [Code quality concerns]
- [Maintainability issues]

Goals:
- [Specific improvements desired]
- [Performance targets]
- [Readability goals]

Constraints:
- [Any limitations or requirements]
- [Backward compatibility needs]
- [Team preferences]

Please provide:
1. Refactored code with explanations
2. Before/after comparison
3. Benefits of the changes
4. Testing recommendations
```

### Architecture Improvement Workflow

**Context Setup**:
1. Open the current architecture files
2. Include design patterns and principles
3. Have related system components visible

**Prompt Structure**:
```
I need to improve the architecture of [system/component]:

Current architecture:
- [Describe current structure]
- [Key components and relationships]
- [Data flow patterns]

Problems:
- [Specific architectural issues]
- [Scalability concerns]
- [Maintainability problems]

Goals:
- [Desired improvements]
- [Performance targets]
- [Scalability requirements]

Please help me:
1. Analyze current architecture
2. Suggest improvements
3. Provide migration strategy
4. Recommend patterns to follow
```

## 📊 Workflow Best Practices

### Preparation
1. **Gather Context**: Open relevant files and documentation
2. **Define Scope**: Be clear about what you want to achieve
3. **Set Constraints**: Specify limitations and requirements
4. **Prepare Examples**: Have good examples visible for reference

### Execution
1. **Start Simple**: Begin with basic requirements
2. **Iterate**: Refine based on AI outputs
3. **Validate**: Test generated code thoroughly
4. **Document**: Record successful patterns for reuse

### Follow-up
1. **Review**: Analyze what worked and what didn't
2. **Refine**: Update your context based on results
3. **Share**: Document successful workflows for your team
4. **Improve**: Continuously enhance your workflow patterns

## 🎯 Workflow Templates

### Quick Component Template
```
Create a [component type] for [purpose]:
- Props: [list props]
- Features: [list features]
- Styling: [styling approach]
- Follow patterns from [reference component]
```

### Debug Template
```
Error: [error message]
Context: [relevant files and code]
Attempted: [what you've tried]
Help: [specific assistance needed]
```

### Refactor Template
```
Refactor [target] to improve [aspects]:
- Issues: [current problems]
- Goals: [desired outcomes]
- Constraints: [limitations]
- Provide: [what you need]
```

## 📖 Next Steps

- **[Context Engineering](context_engineering.md)** - Learn to provide effective context for workflows
- **[Advanced Prompting](advanced_prompting.md)** - Master sophisticated techniques for complex workflows
- **[Production Templates](../cdf_framework/templates/instructions/)** - Apply workflows to CDF development

## 🚀 Getting Started

1. **Choose a Workflow**: Start with a simple code generation workflow
2. **Prepare Context**: Set up your `.cursor/rules.md` and open relevant files
3. **Follow the Template**: Use the provided prompt structures
4. **Iterate and Improve**: Refine based on results
5. **Document Success**: Record what works for your team

---

**Ready to accelerate your development?** Start with a **[Code Generation Workflow](#react-component-generation)** and build from there.
