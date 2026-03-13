# Agent 协作文档索引

本文档集合用于让 agent 在本项目中稳定、高质量地执行任务。

## 文档列表

1. `PROJECT_BRIEF.md`
   - 项目定位、当前状态、里程碑与差距。
2. `AGENT_WORKFLOW.md`
   - 标准执行流程（接单 -> 实施 -> 验证 -> 交付）。
3. `TASK_TEMPLATE.md`
   - 任务描述模板，减少来回确认。
4. `DONE_CHECKLIST.md`
   - 合并前检查项（功能、质量、性能、合规）。

## 使用顺序

1. 先看 `PROJECT_BRIEF.md` 建立上下文。
2. 按 `AGENT_WORKFLOW.md` 执行任务。
3. 新需求按 `TASK_TEMPLATE.md` 补齐信息。
4. 提交前逐条过 `DONE_CHECKLIST.md`。

## 与 `.agent/AGENTS.md` 的关系

`.agent/AGENTS.md` 是最高优先级行为约束；本目录其他文档只补充执行细节，不替代该约束。
