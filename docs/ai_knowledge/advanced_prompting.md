# Advanced Prompting Techniques

Master sophisticated prompting methods that go beyond basic instructions to tackle complex reasoning tasks and generate high-quality, reliable outputs.

## 🎯 Beyond Basic Prompting

While simple prompts work for straightforward tasks, complex software development requires advanced techniques that elicit reasoning, ensure consistency, and handle multi-step logic.

## 🧠 Reasoning Techniques

### Chain of Thought (CoT) Prompting
**Purpose**: Encourage step-by-step reasoning for complex problems

**When to Use**:
- Algorithm design and implementation
- Debugging complex control flows
- Multi-file refactoring planning
- Architectural decision-making

**Example**:
```
I need to implement a rate limiter for an API endpoint using the token bucket algorithm. 
Let's think step by step to build the solution in Go, considering concurrent access.

1. First, let's understand the token bucket algorithm...
2. Next, we need to handle concurrent access safely...
3. Then, we'll implement the rate limiting logic...
4. Finally, we'll add configuration options...
```

**Benefits**: Dramatically improves performance on tasks requiring multi-step logic

### Self-Consistency
**Purpose**: Generate multiple reasoning paths and select the most consistent answer

**When to Use**:
- Financial calculations requiring high accuracy
- Cryptographic functions and security code
- Core business logic algorithms
- Any task where correctness is paramount

**Process**:
1. Generate multiple diverse chains of thought for the same problem
2. Select the most consistent answer from the outputs
3. Use a final prompt to analyze alternatives and select the most robust implementation

**Benefits**: Improves performance by 17.9% on reasoning benchmarks

### Tree of Thought (ToT) Prompting
**Purpose**: Explore multiple distinct reasoning paths simultaneously

**When to Use**:
- Open-ended design problems
- Architectural pattern selection
- Comparing multiple valid solutions
- Evaluating trade-offs between approaches

**Example**:
```
Propose three different architectural patterns for implementing a real-time notification service. 
For each pattern (WebSockets, Server-Sent Events, Long Polling), evaluate the pros and cons 
regarding scalability, latency, and implementation complexity.
```

**Benefits**: Allows exploration of multiple solution paths and backtracking from dead ends

## 👤 Persona and Knowledge Techniques

### Role Prompting (Meta Prompting)
**Purpose**: Instruct the AI to act as an expert in a specific domain

**When to Use**:
- Code reviews and security audits
- Performance optimization
- Writing domain-specific code
- Architectural reviews

**Example**:
```
Act as a principal software engineer specializing in database performance. 
Review the following SQL query and schema. Identify performance bottlenecks 
and suggest optimizations, including index recommendations and query rewrites.
```

**Benefits**: Leverages patterns associated with expert personas in training data

### Generated Knowledge Prompting
**Purpose**: Ask the model to generate relevant facts before attempting the main task

**When to Use**:
- Security-sensitive code generation
- Domain-specific implementations
- Complex algorithm development
- Compliance-related code

**Example**:
```
Before writing the code, first list the key security principles of the OWASP Top 10 
for web applications. Then, using these principles, write a secure user registration 
function in Node.js using Express and bcrypt.
```

**Benefits**: Grounds the model's response in explicit knowledge, reducing hallucination

## 📋 Structured Prompting

### Clear Delimiters
Use clear separators to partition your prompt logically:

```xml
<role>You are an expert system that converts natural language descriptions into valid JSON objects.</role>
<instructions>
Read the user's request and generate a JSON object representing a new user profile. 
The JSON object must conform to the provided schema. Ensure all fields are correctly typed.
</instructions>
<context>
JSON Schema to follow:
{
  "type": "object",
  "properties": {
    "username": {"type": "string"},
    "email": {"type": "string", "format": "email"},
    "isActive": {"type": "boolean"},
    "roles": {"type": "array", "items": {"type": "string"}}
  },
  "required": ["username", "email", "isActive"]
}
</context>
<user_request>
Create a new active user named 'jdoe' with the email 'jdoe@example.com'. 
They should have 'editor' and 'viewer' roles.
</user_request>
<format>Provide only the valid JSON object as your response.</format>
```

### Output Format Specification
For programmatically consumed outputs, explicitly define the desired structure:

```
Generate a JSON response with the following structure:
{
  "function_name": "string",
  "parameters": ["array", "of", "strings"],
  "return_type": "string",
  "complexity": "O(n)"
}
```

## 🎯 Technique Selection Guide

| Technique | Best For | Complexity | Example Use Case |
|-----------|----------|------------|------------------|
| **Zero-Shot** | Simple, well-defined tasks | Low | "Write a Python function to reverse a string" |
| **Few-Shot** | Enforcing coding style | Low-Medium | "Generate React components using our team's patterns" |
| **Chain of Thought** | Complex algorithm design | Medium | "Design a system for processing large file uploads" |
| **Self-Consistency** | High-accuracy tasks | High | "Generate three implementations and select the best" |
| **Tree of Thought** | Open-ended design | Very High | "Compare architectural patterns for a notification service" |
| **Role Prompting** | Domain expertise | Low | "Act as a Senior SRE reviewing this Dockerfile" |

## 🛠️ Implementation Best Practices

### Combine Techniques
Don't use techniques in isolation. Combine them for maximum effectiveness:

1. **Start with Role Prompting** to establish expertise
2. **Add Chain of Thought** for complex reasoning
3. **Use Self-Consistency** for critical outputs
4. **Structure with Clear Delimiters** for clarity

### Iterate and Refine
- Test different prompt variations
- Monitor success rates and quality
- Refine based on failure patterns
- Document successful patterns

### Context Integration
Combine advanced prompting with context engineering:
- Provide project-level context in `.cursor/rules.md`
- Include relevant files for feature-level context
- Add specific requirements in task-level context

## 📈 Measuring Success

### Quality Metrics
- **Accuracy**: Percentage of correct outputs
- **Completeness**: Coverage of requirements
- **Consistency**: Uniformity across similar tasks
- **Maintainability**: Code quality and adherence to standards

### Productivity Metrics
- **Time Savings**: Reduction in development time
- **Refactoring Reduction**: Less manual code changes
- **Debugging Speed**: Faster issue resolution
- **Onboarding Acceleration**: Faster new developer productivity

## 🚀 Getting Started

1. **Master the Basics**: Ensure you understand [foundational prompting](prompt_techniques_overview.md)
2. **Practice Chain of Thought**: Start with simple reasoning tasks
3. **Experiment with Roles**: Try different expert personas
4. **Structure Your Prompts**: Use clear delimiters and format specifications
5. **Measure and Iterate**: Track success and refine your approach

## 📖 Next Steps

- **[Prompt Techniques Overview](prompt_techniques_overview.md)** - Foundational prompting styles
- **[Context Engineering](context_engineering.md)** - Combine with context for better results
- **[AI Workflows](ai_workflows/index.md)** - Real-world implementation examples

---

**Ready to master advanced prompting?** Start with **[Context Engineering](context_engineering.md)** to understand how to provide the right context for these techniques.
