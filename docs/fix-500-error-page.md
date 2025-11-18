# Fix: React "Objects are not valid as a React child" Error

## Problem
Build fails with error:
```
Error: Objects are not valid as a React child (found: object with keys {$$typeof, type, key, ref, props, _owner})
```

This happens when you try to render a React component object directly instead of calling it with JSX.

## Common Causes

### 1. Rendering Component Object Directly
```tsx
// ❌ WRONG
export default function ErrorPage() {
  return { ErrorComponent }  // This is an object, not JSX
}

// ✅ CORRECT
export default function ErrorPage() {
  return <ErrorComponent />  // This is JSX
}
```

### 2. Component in Array Without JSX
```tsx
// ❌ WRONG
const components = [Component1, Component2]
return <div>{components}</div>

// ✅ CORRECT
const components = [<Component1 key="1" />, <Component2 key="2" />]
return <div>{components}</div>
```

### 3. Function Returning Component Object
```tsx
// ❌ WRONG
const renderError = () => ErrorComponent

// ✅ CORRECT
const renderError = () => <ErrorComponent />
```

## Fix for OpsSight Repository

1. **Find the 500 error page:**
   - Check `frontend/app/500.tsx` or `frontend/pages/500.tsx`
   - Or `frontend/app/_error.tsx` (Next.js 13+)

2. **Ensure it returns JSX, not a component object:**
   ```tsx
   // Example correct 500.tsx
   export default function Custom500() {
     return (
       <div>
         <h1>500 - Server Error</h1>
         <p>Something went wrong</p>
       </div>
     )
   }
   ```

3. **Check for any component references:**
   - Search for patterns like `{ComponentName}` without JSX
   - Replace with `<ComponentName />`

4. **Verify all imports are used correctly:**
   - Components should be imported and used with JSX syntax
   - Not passed as objects or references

## Quick Fix Template

Use the `apps/client/src/app/500.tsx` file in this repo as a reference template.

