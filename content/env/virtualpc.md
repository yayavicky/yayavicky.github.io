## 1. 虚拟机文件



文件名示例 | 文件类型
-- | --
`VM_name.vmx` | 配置文件
`VM_name.vswp`  `vmx-VM_name.vswp` | 交换文件
`VM_name.nvram` | BIOS文件
`vmware.log` | 日志文件
`VM_name.vmtx` |  模板文件
`VM_name-rdm.vmdk` |  裸设备映射文件
`VM_name.vmdk` | 磁盘描述符文件
`VM_name-flat.vmdk` |  磁盘数据文件
`VM_name.vmss` | 挂起状态文件
`VM_name.vmsd` | 快照数据文件
`VM_name-Snapshot.vmsn` | 快照状态文件
`VM_name-#####.delta.vmdk` | 快照磁盘文件
`VM_name-Snapshot#.vmem` | 快照活动内存文件



虚拟机默认磁盘模式： 允许创建快照

可选磁盘模式： 独立模式-》永久性磁盘或非永久性

磁盘调配策略： 厚配置延迟清零、厚配置立即清零或精简配置



+ 厚配置使用创建虚拟磁盘时定义的所以磁盘空间
  + 无论客户操作系统文件系统中的数据量如何，虚拟机磁盘均会使用创建时定义的所有容量。
+ 立即清零 或 延迟清零
  + 在立即清零厚配置磁盘中的每个数据块中，都预先填充了一个零。
  + 在向延迟清零厚配置磁盘中的每个数据块写入数据时，都会在该数据块中填充一个零。



关键虚拟机，建议用厚模式。

