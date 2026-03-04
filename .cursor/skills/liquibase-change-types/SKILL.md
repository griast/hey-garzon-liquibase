---
name: "liquibase-change-types"
description: "All available Liquibase change types with their structure, rules, and rollback patterns for PostgreSQL."
category: "database"
tags: ["liquibase", "postgresql", "changesets", "database-migration", "ddl"]
---

# Liquibase Change Types

## Overview

### What This Skill Defines
- **Change Type Structures**: Standard YAML structures for each change type
- **Change Type Rules**: Mandatory rules and conventions for each change type
- **Rollback Patterns**: Standard rollback implementations for each change type
- **Examples**: Complete examples for each change type

### Key Outcomes
- Consistent changeset structure across all change types
- Proper rollback implementation for all changes
- Clear templates for creating new changesets

### ChangeSet ID Format

**Mandatory Rules:**
- ID must be unique across the entire changelog
- Use hyphens to separate words
- ID must be descriptive enough to understand the change

**Project Conventions**:
- Include version at the end (e.g., `v3.1.0`, `v1.0.1`)
- Pattern: `{description}-{version}`

**Examples:**
- `add-default-parameter-v3.1.0`
- `update-unique-constraint-user-detail-v3.1.1`

### File and Directory Context

**Changelog file naming:** `changelog.{category}.v{version}.yaml`

**Directory categories:**

| Directory | Purpose |
|-----------|---------|
| `tables/` | Table operations, columns, constraints, indexes, data load |
| `views/` | Database views |
| `functions/` | Stored procedures, functions, triggers |
| `data/` | CSV files for data migrations and seed data |
| `sql/` | SQL files for complex operations |

**Path formats:**
- SQL files: `changelog/v{major-version}/sql/{script_name}.sql`
- Data files: `changelog/v{major-version}/data/{table_name}.csv`
- All paths are relative to `database/` directory

### ChangeSet Structure

**Mandatory Rules:**
- Every changeset **MUST** include a `rollback` section
- Every changeset **MUST** have a unique `id` and an `author`

**Project Conventions** :
- Include `tagDatabase` as the first change (enables `rollback --tag` for precise version targeting)
- Use `@gmail.com` email for the author field

```yaml
- changeSet:
    id: {description}-{version}
    author: user@gmail.com
    changes:
      - tagDatabase:
          tag: {version}
      # ... change types go here ...
      - rollback:
          # ... rollback operations ...
```

---

## When to Use This Skill

Use this skill when:
- ✅ Creating a new changeset and need to know the structure for a specific change type
- ✅ Understanding the rules and conventions for a change type
- ✅ Implementing rollback logic for a changeset
- ✅ Verifying that a changeset follows the correct structure

**Typical Tasks**:
- Create table changesets
- Add/modify/drop columns
- Create indexes and constraints
- Load data from CSV files
- Execute SQL statements
- Implement rollback logic

---

## Common Change Types

### Create Table (createTable)

**Standard structure for tables:**
```yaml
- createTable:
    schemaName: public
    tableName: {table_name}
    columns:
      - column:
          name: id
          type: UUID
          remarks: "{table_name} unique ID"
          defaultValueComputed: "gen_random_uuid()"
          constraints:
            nullable: false
            primaryKey: true
            unique: true
      - column:
          name: created_at
          type: TIMESTAMP
          remarks: "when the record was created"
          defaultValueComputed: "CURRENT_TIMESTAMP"
          constraints:
            nullable: false
      - column:
          name: updated_at
          type: TIMESTAMP
          remarks: "when the record was updated"
      - column:
          name: enabled
          type: BOOLEAN
          remarks: "enable the record"
          defaultValueBoolean: true
      # ... other columns
```

**Mandatory Rules:**
- Always specify `schemaName` explicitly (avoids ambiguity across environments)
- Table names must be in **lowercase**
- Use `remarks` to document each column

**Project Conventions** :
- Use `schemaName: public` (all tables live in the `public` schema)
- Table names in **singular form** (e.g., `user` not `users`)
- Tables must have standard columns: `id` (UUID, PK), `created_at`, `updated_at`, `enabled`
- Foreign key naming: `fk_{current_table}_{referenced_table}`

**Rollback:**
```yaml
- rollback:
    - dropTable:
        cascadeConstraints: true
        tableName: {table_name}
```

### Add Column (addColumn)

**Structure:**
```yaml
- addColumn:
    schemaName: public
    tableName: {table_name}
    columns:
      - column:
          name: {column_name}
          type: {type}
          remarks: "{description}"
          constraints:
            nullable: {true|false}
            # If it's a FK:
            foreignKeyName: fk_{table}_{referenced_table}
            referencedTableName: {referenced_table}
            referencedColumnNames: id
```

**Rollback:**
```yaml
- rollback:
    - dropColumn:
        columnName: {column_name}
        tableName: {table_name}
```

### Drop Column (dropColumn)

**Structure:**
```yaml
- dropColumn:
    schemaName: public
    tableName: {table_name}
    columns:
      - column:
          name: {column_name}
```

**Rollback:**
```yaml
- rollback:
    - addColumn:
        tableName: {table_name}
        columns:
          - column:
              name: {column_name}
              type: {original_type}
              remarks: "{original_description}"
              # ... original constraints
```

### Rename Column (renameColumn)

**Structure:**
```yaml
- renameColumn:
    newColumnName: {new_name}
    oldColumnName: {old_name}
    schemaName: public
    tableName: {table_name}
```

**Rollback:**
```yaml
- rollback:
    - renameColumn:
        newColumnName: {old_name}
        oldColumnName: {new_name}
        schemaName: public
        tableName: {table_name}
```

### Modify Data Type (modifyDataType)

**Structure:**
```yaml
- modifyDataType:
    schemaName: public
    columnName: {column_name}
    newDataType: {new_type}
    tableName: {table_name}
```

**Rollback:**
```yaml
- rollback:
    - modifyDataType:
        columnName: {column_name}
        newDataType: {old_type}
        tableName: {table_name}
```

### Direct SQL (sql)

**Structure:**
```yaml
- sql: |
    {sql_statements}
```

**Rules:**
- Use `|` for multiline blocks

**Example:**
```yaml
- sql: |
    INSERT INTO airport (name, created_at, updated_at, enabled) VALUES
    ('MIA', NOW(), NULL, true);
```

**Rollback:**
```yaml
- rollback:
    - sql: |
        {sql_statements_to_revert}
```

### SQL from File (sqlFile)

**Structure:**
```yaml
- sqlFile:
    path: changelog/{major-version}/sql/{version}/{file_name}.sql
```

**Rules:**
- SQL files must be in `changelog/{major-version}/sql/{version}/`
- Use descriptive names: `v3.06-upgrade-commodity-airport-user-audit-view.sql`
- For rollback, use a separate file: `v3.06-upgrade-commodity-airport-user-audit-view-rollback.sql`

**Rollback:**
```yaml
- rollback:
    - sqlFile:
        path: changelog/{major-version}/sql/{version}/{rollback_file_name}.sql
```

### Load Data (loadData)

**Structure:**
```yaml
- loadData:
    schemaName: public
    tableName: {table_name}
    columns:
      - column:
          header: {csv_header_name}
          name: {column_name}
          type: {type}
    encoding: UTF-8
    file: changelog/{major-version}/data/{file_name}.csv
    separator: ","
```

**Rollback:**
```yaml
- rollback:
    - sql: |
        DELETE FROM {table_name}
        WHERE {unique_column} IN ({values_from_csv});
```

### Create Index (createIndex)

**Structure:**
```yaml
- createIndex:
    schemaName: public
    tableName: {table_name}
    indexName: {index_name}
    columns:
      - column:
          name: {column_name}
```

**Rules:**
- Index name: `{table}_{column(s)}_idx` or descriptive
- Use `IF NOT EXISTS` in direct SQL

**Rollback:**
```yaml
- rollback:
    - dropIndex:
        tableName: {table_name}
        indexName: {index_name}
```

### Unique Constraints (addUniqueConstraint / dropUniqueConstraint)

**Add:**
```yaml
- addUniqueConstraint:
    schemaName: public
    tableName: {table_name}
    columnNames: {column1}, {column2}
    constraintName: {constraint_name}
```

**Drop:**
```yaml
- dropUniqueConstraint:
    schemaName: public
    constraintName: {constraint_name}
    tableName: {table_name}
```

**Rollback:**
- Reverse the operation (add if dropped, drop if added)

### Drop Table (dropTable)

**Structure:**
```yaml
- dropTable:
    schemaName: public
    cascadeConstraints: true
    tableName: {table_name}
```

**Rollback:**
- Recreate the table with its original structure using `createTable`

### Update Data (update)

**Structure:**
```yaml
- update:
    schemaName: public
    tableName: {table_name}
    columns:
      - column:
          name: {column_name}
          valueComputed: {sql_expression}
```

**Rollback:**
- Revert to original values or use direct SQL

### Foreign Key Constraints (addForeignKeyConstraint / dropForeignKeyConstraint)

**Add:**
```yaml
- addForeignKeyConstraint:
    baseTableSchemaName: public
    baseTableName: {current_table}
    baseColumnNames: id_{referenced_table}
    constraintName: fk_{current_table}_{referenced_table}
    referencedTableName: {referenced_table}
    referencedColumnNames: id
```

**Drop:**
```yaml
- dropForeignKeyConstraint:
    baseTableSchemaName: public
    baseTableName: {current_table}
    constraintName: fk_{current_table}_{referenced_table}
```

**Rules:**
- Naming: `fk_{current_table}_{referenced_table}`
- Examples: `fk_commodity_user_audit`, `fk_airport_user_audit`, `fk_region_commodity`
- For FK columns: use `id_{referenced_table}`

**Rollback:**
- Reverse the operation (add if dropped, drop if added)

### Create View (createView / dropView)

**Create:**
```yaml
- createView:
    viewName: {view_name}
    schemaName: public
    selectQuery: SELECT ... FROM ...
```

**Drop:**
```yaml
- dropView:
    viewName: {view_name}
    schemaName: public
```

**Rules:**
- Place view changesets in `changelog/v{major-version}/views/changelog.views.v{version}.yaml`
- Use descriptive view names in snake_case

**Rollback:**
- Reverse the operation (create if dropped, drop if created)

### Not Null Constraint (addNotNullConstraint / dropNotNullConstraint)

**Add:**
```yaml
- addNotNullConstraint:
    schemaName: public
    tableName: {table_name}
    columnName: {column_name}
    columnDataType: {type}
    constraintName: nn_{table}_{column}
```

**Drop:**
```yaml
- dropNotNullConstraint:
    schemaName: public
    tableName: {table_name}
    columnName: {column_name}
    columnDataType: {type}
```

**Rollback:**
- Reverse the operation (add if dropped, drop if added)

### Default Value (addDefaultValue / dropDefaultValue)

**Add:**
```yaml
- addDefaultValue:
    schemaName: public
    tableName: {table_name}
    columnName: {column_name}
    columnDataType: {type}
    defaultValue: {value}
    defaultValueComputed: {expression}
```

**Drop:**
```yaml
- dropDefaultValue:
    schemaName: public
    tableName: {table_name}
    columnName: {column_name}
    columnDataType: {type}
```

**Rollback:**
- Reverse the operation (add if dropped, drop if added)

### Rename Table (renameTable)

**Structure:**
```yaml
- renameTable:
    oldTableName: {old_name}
    newTableName: {new_name}
    schemaName: public
```

**Rules:**
- Use snake_case for both old and new names
- Use singular form for table names

**Rollback:**
```yaml
- rollback:
    - renameTable:
        oldTableName: {new_name}
        newTableName: {old_name}
        schemaName: public
```

---

## Rollback Rules

### General Rules:
1. **ALWAYS** include a `rollback` section in each changeset
2. The rollback must completely revert all changes made
3. Maintain reverse order of operations when there are multiple changes
4. Use the same structure as the original change (sql -> sql, sqlFile -> sqlFile, etc.)

### Rollback Structure:
```yaml
- rollback:
    - {rollback_type}:
        # ... configuration
```

### Rollback Types:
- `sql`: To revert direct SQL
- `sqlFile`: To use SQL rollback file
- `dropTable`: To revert `createTable`
- `addColumn`: To revert `dropColumn`
- `dropColumn`: To revert `addColumn`
- `renameColumn`: To revert `renameColumn`
- `modifyDataType`: To revert `modifyDataType`
- `dropIndex`: To revert `createIndex`
- `createIndex`: To revert `dropIndex`
- `dropForeignKeyConstraint`: To revert `addForeignKeyConstraint`
- `addForeignKeyConstraint`: To revert `dropForeignKeyConstraint`
- `dropView`: To revert `createView`
- `createView`: To revert `dropView`

---

## Common Column Patterns

### Standard Columns in Tables
1. **id**: UUID, PK, unique, `gen_random_uuid()`
2. **created_at**: TIMESTAMP, NOT NULL, `CURRENT_TIMESTAMP`
3. **updated_at**: TIMESTAMP, nullable
4. **enabled**: BOOLEAN, default `true`

### Common Data Types
- `UUID`: For IDs and foreign keys
- `VARCHAR(n)`: For strings with specific length
- `VARCHAR`: For strings without specific length
- `INT` / `BIGINT`: For integers
- `FLOAT`: For decimal numbers
- `BOOLEAN`: For boolean values
- `TIMESTAMP`: For dates and times
- `JSONB`: For JSON data (PostgreSQL 9.4+)

---

## Naming Conventions

**Mandatory Rules:**
- Use snake_case for all names (tables, columns, constraints)
- Use lowercase letters only
- Be descriptive and clear
- Avoid unnecessary abbreviations
- Be consistent with existing names in the schema

**Project Conventions** :

| Element | Convention | Examples |
|---------|-----------|----------|
| Table names | Singular form | `user`, `user_piece`, `airport` |
| FK columns | `id_{referenced_table}` | `id_commodity`, `id_airport` |
| FK constraints | `fk_{current_table}_{referenced_table}` | `fk_commodity_user_audit` |
| Unique constraints | `{table}_{columns}_unique` | `user_audit_commodity_unique` |
| Indexes | `{table}_{column(s)}_idx` | `user_audit_commodity_idx` |

---

## Best Practices

### Idempotency
- Use `IF EXISTS` / `IF NOT EXISTS` in DDL
- Use `WHERE NOT EXISTS` in INSERTs
- Verify existence before creating/dropping

### Organization
- Group related changes in the same changeset
- Keep independent changes in separate changesets
- Use `sqlFile` for complex or long changes

### Documentation
- Include `remarks` in all columns
- Use descriptive IDs
- Comment complex SQL

### Versioning
- Increment version sequentially
- Do not reuse version numbers
- Maintain consistency between ID and tag

### Language
- **ALWAYS** describe changes in English
- All `remarks` in columns must be in English
- All comments in SQL must be in English

### Testing
- Test the changeset in development environment
- Verify that rollback works correctly
- Ensure there are no circular dependencies

---

## Common Pitfalls

### Anti-patterns and Solutions

**Mandatory issues** (will break migrations):

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Missing rollback blocks | Changeset cannot be reverted | ALWAYS include `rollback` section in every changeset |
| Non-idempotent SQL | Re-running fails or duplicates data | Use `IF EXISTS`/`IF NOT EXISTS` and `WHERE NOT EXISTS` |
| Missing remarks | Poor documentation, hard to maintain | Include `remarks` in all columns describing purpose |
| Wrong path for sqlFile | File not found during migration | Use relative paths from `database/` directory |
| Destructive loadData rollback | `DELETE FROM table` removes pre-existing data | Scope rollback DELETE with WHERE clause on loaded values |

**Convention issues** (won't break, but violates project standards):

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Incorrect FK naming | Inconsistent constraint names | Use `fk_{current_table}_{referenced_table}` format |
| Plural table names | Inconsistent with conventions | Use singular form: `user` not `users` |
| Missing tagDatabase | No version tag for `rollback --tag` | Include `tagDatabase` as first change in every changeset |

### Correct Approaches
- ✅ Test rollback locally before committing
- ✅ Use `cascadeConstraints: true` when dropping tables with FKs
- ✅ Include tagDatabase as first change in every changeset (enables precise rollback by tag)
- ✅ Match tag version with changeset ID version

---

## Complete Examples

### Example: Create Table with Foreign Keys
```yaml
- changeSet:
    id: changelog-create-user-audit-v3.1.0
    author: user@gmail.com
    changes:
      - tagDatabase:
          tag: v3.1.0
      - createTable:
          schemaName: public
          tableName: user_audit
          columns:
            - column:
                name: id
                type: UUID
                remarks: "user audit unique ID"
                defaultValueComputed: "gen_random_uuid()"
                constraints:
                  nullable: false
                  primaryKey: true
                  unique: true
            - column:
                name: id_commodity
                type: UUID
                remarks: "commodity FK"
                constraints:
                  nullable: false
                  foreignKeyName: fk_commodity_user_audit
                  referencedTableName: commodity
                  referencedColumnNames: id
            - column:
                name: created_at
                type: TIMESTAMP
                remarks: "when the record was created"
                defaultValueComputed: "CURRENT_TIMESTAMP"
                constraints:
                  nullable: false
            - column:
                name: updated_at
                type: TIMESTAMP
                remarks: "when the record was updated"
            - column:
                name: enabled
                type: BOOLEAN
                remarks: "enable the record"
                defaultValueBoolean: true
      - addUniqueConstraint:
          columnNames: id_commodity, id_airport, id_user
          constraintName: unique_key_user_audit
          tableName: user_audit
      - rollback:
          - dropTable:
              cascadeConstraints: true
              tableName: user_audit
```

### Example: Insert Data with Verification (Idempotent)
```yaml
- changeSet:
    id: add-zero-policy-user-reason-v3.1.0
    author: user@gmail.com
    changes:
      - tagDatabase:
          tag: v3.1.0
      - sql: |
          INSERT INTO user_reason (name, created_at, updated_at, enabled, tags, num_in_file)
          SELECT 'Zero Policy', NOW(), NULL, true, NULL, NULL
          WHERE NOT EXISTS (SELECT 1 FROM user_reason WHERE name = 'Zero Policy');
      - rollback:
          - sql: |
              DELETE FROM user_reason WHERE name = 'Zero Policy';
```

---

## Validation Checklist

### Mandatory (must pass for any Liquibase project)

- [ ] The changeset ID is unique across the entire changelog
- [ ] All changes are correctly structured (valid Liquibase YAML)
- [ ] The rollback is complete and reverts all changes
- [ ] `IF EXISTS` / `IF NOT EXISTS` are used when appropriate
- [ ] Columns have descriptive `remarks` in English
- [ ] Data types are appropriate for the use case
- [ ] If using `sqlFile`, the file exists and is in the correct path
- [ ] All paths in changesets use relative paths from `database/`
- [ ] `schemaName` is explicitly specified in all applicable change types
- [ ] The changeset has been tested in development
- [ ] All descriptions and comments are in English

### Project Conventions 

- [ ] `schemaName` uses `public` (standard schema)
- [ ] The ID follows the pattern `{description}-{version}`
- [ ] The author has the correct `@gmail.com` email format
- [ ] `tagDatabase` is the first change, with tag matching the version
- [ ] Foreign keys follow the naming pattern `fk_{current_table}_{referenced_table}`
- [ ] File names follow the naming convention: `changelog.{category}.v{version}.yaml`
- [ ] Files are placed in the correct category directory
- [ ] Master changelog includes all category files

---

## Related Skills

- **liquibase-agent-capabilities**: For validation workflows, permitted commands, and local environment restrictions. Use when determining what the agent can execute and how to validate changesets.
- **constitution**: For architectural principles, layer responsibilities, and the rule that BC microservices use Liquibase migration repos instead of creating databases directly.

---

## References

- [Liquibase Change Types](https://docs.liquibase.com/change-types/home.html)

