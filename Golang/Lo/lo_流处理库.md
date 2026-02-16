# loBoot
```go
// 模拟从两个渠道获取的原始数据（二维切片）
	nestedRecords := [][]RawRecord{
		{
			{ID: 1, UserID: 101, Source: "Web", Status: "valid"},
			{ID: 2, UserID: 102, Source: "Web", Status: "invalid"}, // 无效
		},
		{
			{ID: 3, UserID: 101, Source: "App", Status: "valid"}, // UserID 101 重复了
			{ID: 4, UserID: 103, Source: "App", Status: "valid"},
			{ID: 5, UserID: 104, Source: "App", Status: "valid"},
			{ID: 6, UserID: 105, Source: "App", Status: "valid"},
		},
	}

	// 开始流水线处理

	// 1. Flatten: 将二维切片拍平为一维 []RawRecord
	flatRecords := lo.Flatten(nestedRecords)

	// 2. Filter: 只保留有效数据
	validRecords := lo.Filter(flatRecords, func(r RawRecord, _ int) bool {
		return r.Status == "valid"
	})

	// 3. Map: 转换为 Reward 结构体（统一格式）
	rewards := lo.Map(validRecords, func(r RawRecord, _ int) Reward {
		return Reward{
			UID: r.UserID,
			Msg: fmt.Sprintf("来自%s的奖励", r.Source),
		}
	})

	// 4. UniqBy: 按 UserID 去重，每个用户只发一次奖
	uniqueRewards := lo.UniqBy(rewards, func(r Reward) int {
		return r.UID
	})
	//4.5 GroupBy: 按 Msg 分组，看看每种奖励有多少人获得
	groupBy := lo.GroupBy(uniqueRewards, func(value Reward) string {
		return value.Msg
	})

	// 5. Slice: 只要前 3 名 (索引 0 到 3，不包含 3)
	top3Rewards := lo.Slice(uniqueRewards, 0, 3)

	// 6. Chunk: 每 2 个一组，准备分批写入数据库
	batches := lo.Chunk(top3Rewards, 2)

	// 输出结果
	fmt.Printf("最终批次数量: %d\n", len(batches))
	for i, batch := range batches {
		fmt.Printf("第 %d 批次发送给: %+v\n", i+1, batch)
	}


type RawRecord struct {
	ID     int
	UserID int
	Source string
	Status string // "valid" 或 "invalid"
}

type Reward struct {
	UID int
	Msg string
}
```

# 底层

## callback
- 底层通过回调函数和range迭代器实现

## range
- 如果要求性能,直接手写for range 配合slices/maps包

# 流处理
- fliter(过滤),map(映射),unique(去重),groupby(分组)



