# koda 项目速览（给 Agent）

## 1. 项目目标

- 项目是一个基于 HarmonyOS + ArkTS 的“私有感官终端”实验应用。
- 核心方向：将传感器数据（光照、运动等）转成高表现力的声明式 UI 交互。
- 关键约束：本地化处理、轻量化、模块化、隐私优先（偏向零网络依赖）。

## 2. 当前仓库状态（2026-03-09）

- 已完成最小链路雏形：`LightPerceptionService`（实现 `VibeProvider`）-> `KodaState` -> `Index` 页面绑定。
- 主要入口文件：`entry/src/main/ets/pages/Index.ets`。
- 已有基础测试覆盖：光照归一化、模式分类；需继续增强状态订阅与生命周期回归测试。
- 与路线图相比，当前处于 P1（感官基石）后段，尚未进入 P2 视觉协议的性能调优。

## 3. 路线图重点（来自 `docs/roadmap.md`）

- 技术栈：ArkTS Strict Mode、ArkUI、`@ohos.sensor`、`@ohos.taskpool`、`@ohos.data.relationalStore`、`@ohos.vibrator`。
- 架构层次：
  - 感知抽象层（`VibeProvider` + 预处理/归一化）。
  - 逻辑分发层（单一状态源 `kodaState` + 模式识别）。
  - 表现层（声明式组件堆叠、过渡与动画）。
- 阶段里程碑：
  - P1 感官基础。
  - P2 视觉协议。
  - P3 多模态交互。
  - P4 离线数据实验室。
  - P5 分布式协同。

## 4. 当前关键风险

- 风险1：文档状态若继续滞后，会直接误导任务优先级与验收范围。
- 风险2：真实传感器在不同 SDK/设备上的接口差异可能导致运行时回退到 mock。
- 风险3：若未补状态层回归测试，后续动画与模式策略迭代容易引入静默回归。

## 5. 推荐近期优先级（面向 Agent）

1. 收敛并验证 P1：
   - 真实光照采集（不可用时可控回退）+ 生命周期释放。
2. 补全状态层测试：
   - 覆盖 `subscribe/unsubscribe/updateFromLux` 的行为回归。
3. 再推进 P2 视觉协议：
   - 基于稳定状态模型做动态背景和动画调优。
4. 为 P3 预留接口：
   - 在 `core/perception` 抽象统一 `VibeProvider`，避免后续接入运动传感器时重构页面。

