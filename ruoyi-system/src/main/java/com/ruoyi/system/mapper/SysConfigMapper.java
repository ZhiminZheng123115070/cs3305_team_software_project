package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysConfig;

/**
 * Parameter Configuration Data Layer
 * 
 * @author ruoyi
 */
public interface SysConfigMapper
{
    /**
     * Query Parameter Configuration Information
     * 
     * @param config Parameter Configuration Information
     * @return Parameter Configuration Information
     */
    public SysConfig selectConfig(SysConfig config);

    /**
     * Query Configuration by ID
     * 
     * @param configId Parameter ID
     * @return Parameter Configuration Information
     */
    public SysConfig selectConfigById(Long configId);

    /**
     * Query Parameter Configuration List
     * 
     * @param config Parameter Configuration Information
     * @return Parameter Configuration Collection
     */
    public List<SysConfig> selectConfigList(SysConfig config);

    /**
     * Query Parameter Configuration Information by Key Name
     * 
     * @param configKey Parameter Key Name
     * @return Parameter Configuration Information
     */
    public SysConfig checkConfigKeyUnique(String configKey);

    /**
     * Add Parameter Configuration
     * 
     * @param config Parameter Configuration Information
     * @return Result
     */
    public int insertConfig(SysConfig config);

    /**
     * Modify Parameter Configuration
     * 
     * @param config Parameter Configuration Information
     * @return Result
     */
    public int updateConfig(SysConfig config);

    /**
     * Delete Parameter Configuration
     * 
     * @param configId Parameter ID
     * @return Result
     */
    public int deleteConfigById(Long configId);

    /**
     * Batch Delete Parameter Information
     * 
     * @param configIds Parameter IDs to Delete
     * @return Result
     */
    public int deleteConfigByIds(Long[] configIds);
}
